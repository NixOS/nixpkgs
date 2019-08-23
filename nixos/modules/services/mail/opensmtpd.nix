{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.opensmtpd;
  conf = pkgs.writeText "smtpd.conf" cfg.serverConfiguration;
  args = concatStringsSep " " cfg.extraServerArgs;

  sendmail = pkgs.runCommand "opensmtpd-sendmail" { preferLocalBuild = true; } ''
    mkdir -p $out/bin
    ln -s ${cfg.package}/sbin/smtpctl $out/bin/sendmail
  '';

in {

  ###### interface

  options = {

    services.opensmtpd = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = "Whether to enable the OpenSMTPD server.";
      };

      package = mkOption {
        type = types.package;
        default = pkgs.opensmtpd;
        defaultText = "pkgs.opensmtpd";
        description = "The OpenSMTPD package to use.";
      };

      addSendmailToSystemPath = mkOption {
        type = types.bool;
        default = true;
        description = ''
          Whether to add OpenSMTPD's sendmail binary to the
          system path or not.
        '';
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
    };

  };


  ###### implementation

  config = mkIf cfg.enable {
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

    systemd.services.opensmtpd = let
      procEnv = pkgs.buildEnv {
        name = "opensmtpd-procs";
        paths = [ cfg.package ] ++ cfg.procPackages;
        pathsToLink = [ "/libexec/opensmtpd" ];
      };
    in {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      preStart = ''
        mkdir -p /var/spool/smtpd
        chmod 711 /var/spool/smtpd

        mkdir -p /var/spool/smtpd/offline
        chown root.smtpq /var/spool/smtpd/offline
        chmod 770 /var/spool/smtpd/offline

        mkdir -p /var/spool/smtpd/purge
        chown smtpq.root /var/spool/smtpd/purge
        chmod 700 /var/spool/smtpd/purge
      '';
      serviceConfig.ExecStart = "${cfg.package}/sbin/smtpd -d -f ${conf} ${args}";
      environment.OPENSMTPD_PROC_PATH = "${procEnv}/libexec/opensmtpd";
    };

    environment.systemPackages = mkIf cfg.addSendmailToSystemPath [ sendmail ];
  };
}
