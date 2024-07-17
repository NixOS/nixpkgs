{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let

  cfg = config.services.opensmtpd;
  conf = pkgs.writeText "smtpd.conf" cfg.serverConfiguration;
  args = concatStringsSep " " cfg.extraServerArgs;

  sendmail = pkgs.runCommand "opensmtpd-sendmail" { preferLocalBuild = true; } ''
    mkdir -p $out/bin
    ln -s ${cfg.package}/sbin/smtpctl $out/bin/sendmail
  '';

in
{

  ###### interface

  imports = [
    (mkRenamedOptionModule
      [
        "services"
        "opensmtpd"
        "addSendmailToSystemPath"
      ]
      [
        "services"
        "opensmtpd"
        "setSendmail"
      ]
    )
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
        default = [ ];
        example = [
          "-v"
          "-P mta"
        ];
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
        default = [ ];
        description = ''
          Packages to search for filters, tables, queues, and schedulers.

          Add OpenSMTPD-extras here if you want to use the filters, etc. from
          that package.
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

    services.mail.sendmailSetuidWrapper = mkIf cfg.setSendmail (
      security.wrappers.smtpctl // { program = "sendmail"; }
    );

    systemd.tmpfiles.rules = [
      "d /var/spool/smtpd 711 root - - -"
      "d /var/spool/smtpd/offline 770 root smtpq - -"
      "d /var/spool/smtpd/purge 700 smtpq root - -"
    ];

    systemd.services.opensmtpd =
      let
        procEnv = pkgs.buildEnv {
          name = "opensmtpd-procs";
          paths = [ cfg.package ] ++ cfg.procPackages;
          pathsToLink = [ "/libexec/opensmtpd" ];
        };
      in
      {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig.ExecStart = "${cfg.package}/sbin/smtpd -d -f ${conf} ${args}";
        environment.OPENSMTPD_PROC_PATH = "${procEnv}/libexec/opensmtpd";
      };
  };
}
