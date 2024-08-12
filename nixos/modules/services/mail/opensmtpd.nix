{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.opensmtpd;
  certs = config.security.acme.certs;

  # This path is created by systemd but is predictable if you know the service name
  # See here for discussion: https://github.com/NixOS/nixpkgs/issues/101389#issuecomment-841704851
  certsDir = "/run/credentials/opensmtpd.service";

  # Add each host listed in useACMEHosts to the config as a pki.
  # Certs are assumed to be in the working directory so that we can
  # test the configuration in opensmtp-acme-restart.service
  certConf = concatStringsSep "\n" (concatMap (host: [
    "pki ${host} cert \"${certsDir}/${host}.cert.pem\""
    "pki ${host} key \"${certsDir}/${host}.key.pem\""
  ]) cfg.useACMEHosts);

  # Prepare systemd LoadCredential list
  credsConf = concatMap (host: let
    certDir = certs."${host}".directory;
  in [
    "${host}.cert.pem:${certDir}/cert.pem"
    "${host}.key.pem:${certDir}/key.pem"
  ]) cfg.useACMEHosts;

  certTargets = map (host: "acme-finished-${host}.target") cfg.useACMEHosts;
  certServices = map (host: "acme-${host}.service") cfg.useACMEHosts;

  conf = pkgs.writeText "smtpd.conf" (certConf + "\n" + cfg.serverConfiguration);
  args = concatStringsSep " " cfg.extraServerArgs;

  sendmail = pkgs.runCommand "opensmtpd-sendmail" { preferLocalBuild = true; } ''
    mkdir -p $out/bin
    ln -s ${cfg.package}/sbin/smtpctl $out/bin/sendmail
  '';

in {

  ###### interface

  imports = [
    (mkRenamedOptionModule [ "services" "opensmtpd" "addSendmailToSystemPath" ] [ "services" "opensmtpd" "setSendmail" ])
  ];

  options = {

    services.opensmtpd = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the OpenSMTPD server.";
      };

      package = mkPackageOption pkgs "opensmtpd" { };

      setSendmail = mkOption {
        type = types.bool;
        default = true;
        description = "Whether to set the system sendmail to OpenSMTPD's.";
      };

      extraServerArgs = mkOption {
        type = types.listOf types.str;
        default = [];
        example = [ "-v" "-P mta" ];
        description = ''
          Extra command line arguments provided when the smtpd process
          is started.
        '';
      };

      serverConfiguration = mkOption {
        type = types.lines;
        example = ''
          listen on lo
          accept for any deliver to lmtp localhost:24
        '';
        description = ''
          The contents of the smtpd.conf configuration file. See the
          OpenSMTPD documentation for syntax information.
        '';
      };

      procPackages = mkOption {
        type = types.listOf types.package;
        default = [];
        description = ''
          Packages to search for filters, tables, queues, and schedulers.

          Add OpenSMTPD-extras here if you want to use the filters, etc. from
          that package.
        '';
      };

      useACMEHosts = mkOption {
        type = types.listOf types.str;
        default = [];
        description = ''
          A list of hosts of existing Let's Encrypt certificates to load on start up.
          This will add the appropriate "pki $host" lines to the configuration and add
          systemd service dependencies on the relevant ACME renewal services, but will
          not configure any "listen" directives to use the certificates.
          <emphasis>Note that this option does not create any certificates – you will need
          to create them manually using <option>security.acme.certs</option></emphasis>
        '';
      };
    };
  };


  ###### implementation

  config = mkIf cfg.enable rec {
    users.groups = {
      smtpd.gid = config.ids.gids.smtpd;
      smtpq.gid = config.ids.gids.smtpq;
    };

    users.users = {
      smtpd = {
        description = "OpenSMTPD process user";
        uid = config.ids.uids.smtpd;
        group = "smtpd";
      };
      smtpq = {
        description = "OpenSMTPD queue user";
        uid = config.ids.uids.smtpq;
        group = "smtpq";
      };
    };

    security.wrappers.smtpctl = {
      owner = "root";
      group = "smtpq";
      setuid = false;
      setgid = true;
      source = "${cfg.package}/bin/smtpctl";
    };

    services.mail.sendmailSetuidWrapper = mkIf cfg.setSendmail
      (security.wrappers.smtpctl // { program = "sendmail"; });

    systemd.tmpfiles.rules = [
      "d /var/spool/smtpd 711 root - - -"
      "d /var/spool/smtpd/offline 770 root smtpq - -"
      "d /var/spool/smtpd/purge 700 smtpq root - -"
    ];

    systemd.services.opensmtpd = let
      procEnv = pkgs.buildEnv {
        name = "opensmtpd-procs";
        paths = [ cfg.package ] ++ cfg.procPackages;
        pathsToLink = [ "/libexec/opensmtpd" ];
      };
    in {
      wantedBy = [ "multi-user.target" ];
      wants = certTargets;
      after = [ "network.target" ] ++ certServices;
      serviceConfig = {
        ExecStart = "${cfg.package}/sbin/smtpd -d -f ${conf} ${args}";
        LoadCredential = credsConf;
      };
      environment.OPENSMTPD_PROC_PATH = "${procEnv}/libexec/opensmtpd";
    };

    # This service works in a similar fashion to the httpd/nginx-config-reload services.
    # Its purpose is to collate multiple cert updates into a single service restart.
    systemd.services.opensmtpd-acme-restart = mkIf (cfg.useACMEHosts != []) {
      description = "Restart OpenSMTPD when ACME certificates are updated";
      requisite = [ "opensmtpd.service" ];
      wantedBy = certServices;
      before = certTargets;
      after = [ "opensmtpd.service" ] ++ certServices;
      # Block reloading if not all certs exist yet.
      # Happens when config changes add new certs.
      unitConfig.ConditionPathExists = map (certName: certs.${certName}.directory + "/cert.pem") cfg.useACMEHosts;
      serviceConfig = {
        Type = "oneshot";
        TimeoutSec = 60;
        ExecStart = "/run/current-system/systemd/bin/systemctl restart opensmtpd.service";
      };
    };
  };
}
