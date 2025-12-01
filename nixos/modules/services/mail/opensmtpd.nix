{
  config,
  lib,
  pkgs,
  ...
}:
let

  cfg = config.services.opensmtpd;
  conf = pkgs.writeText "smtpd.conf" cfg.serverConfiguration;
  args = lib.concatStringsSep " " cfg.extraServerArgs;

  sendmail = pkgs.runCommand "opensmtpd-sendmail" { } ''
    mkdir -p $out/bin
    ln -s ${cfg.package}/sbin/smtpctl $out/bin/sendmail
  '';

in
{

  ###### interface

  imports = [
    (lib.mkRenamedOptionModule
      [ "services" "opensmtpd" "addSendmailToSystemPath" ]
      [ "services" "opensmtpd" "setSendmail" ]
    )
  ];

  options = {

    services.opensmtpd = {

      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to enable the OpenSMTPD server.";
      };

      package = lib.mkPackageOption pkgs "opensmtpd" { };

      setSendmail = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Whether to set the system sendmail to OpenSMTPD's.";
      };

      extraServerArgs = lib.mkOption {
        type = lib.types.listOf lib.types.str;
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

      serverConfiguration = lib.mkOption {
        type = lib.types.lines;
        example = ''
          listen on lo
          accept for any deliver to lmtp localhost:24
        '';
        description = ''
          The contents of the smtpd.conf configuration file. See the
          OpenSMTPD documentation for syntax information.
        '';
      };

      procPackages = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = [ ];
        description = ''
          Packages to search for filters, tables, queues, and schedulers.

          Add packages here if you want to use them as as such, for example
          from the opensmtpd-table-* packages.
        '';
      };
    };

  };

  ###### implementation

  config = lib.mkIf cfg.enable rec {
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

    services.mail.sendmailSetuidWrapper = lib.mkIf cfg.setSendmail (
      security.wrappers.smtpctl
      // {
        source = "${sendmail}/bin/sendmail";
        program = "sendmail";
      }
    );

    systemd.tmpfiles.settings.opensmtpd = {
      "/var/spool/smtpd".d = {
        mode = "0711";
        user = "root";
      };
      "/var/spool/smtpd/offline".d = {
        mode = "0770";
        user = "root";
        group = "smtpq";
      };
      "/var/spool/smtpd/purge".d = {
        mode = "0700";
        user = "smtpq";
        group = "root";
      };
      "/var/spool/smtpd/queue".d = {
        mode = "0700";
        user = "smtpq";
        group = "root";
      };
    };

    systemd.services.opensmtpd =
      let
        procEnv = pkgs.buildEnv {
          name = "opensmtpd-procs";
          paths = [ cfg.package ] ++ cfg.procPackages;
          pathsToLink = [ "/libexec/smtpd" ];
        };
      in
      {
        wantedBy = [ "multi-user.target" ];
        after = [ "network.target" ];
        serviceConfig.ExecStart = "${cfg.package}/sbin/smtpd -d -f ${conf} ${args}";
        environment.OPENSMTPD_PROC_PATH = "${procEnv}/libexec/smtpd";
      };
  };
}
