{ config, lib, ... }:

let

  inherit (lib.attrsets) hasAttr;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) nonEmptyStr nullOr;

  options.services.tsmBackup = {
    enable = mkEnableOption ''
      automatic backups with the
      IBM Spectrum Protect (Tivoli Storage Manager, TSM) client.
      This also enables
      <option>programs.tsmClient.enable</option>
    '';
    command = mkOption {
      type = nonEmptyStr;
      default = "backup";
      example = "incr";
      description = ''
        The actual command passed to the
        <literal>dsmc</literal> executable to start the backup.
      '';
    };
    servername = mkOption {
      type = nonEmptyStr;
      example = "mainTsmServer";
      description = ''
        Create a systemd system service
        <literal>tsm-backup.service</literal> that starts
        a backup based on the given servername's stanza.
        Note that this server's
        <option>passwdDir</option> will default to
        <filename>/var/lib/tsm-backup/password</filename>
        (but may be overridden);
        also, the service will use
        <filename>/var/lib/tsm-backup</filename> as
        <literal>HOME</literal> when calling
        <literal>dsmc</literal>.
      '';
    };
    autoTime = mkOption {
      type = nullOr nonEmptyStr;
      default = null;
      example = "12:00";
      description = ''
        The backup service will be invoked
        automatically at the given date/time,
        which must be in the format described in
        <citerefentry><refentrytitle>systemd.time</refentrytitle><manvolnum>5</manvolnum></citerefentry>.
        The default <literal>null</literal>
        disables automatic backups.
      '';
    };
  };

  cfg = config.services.tsmBackup;
  cfgPrg = config.programs.tsmClient;

  assertions = [
    {
      assertion = hasAttr cfg.servername cfgPrg.servers;
      message = "TSM service servername not found in list of servers";
    }
    {
      assertion = cfgPrg.servers.${cfg.servername}.genPasswd;
      message = "TSM service requires automatic password generation";
    }
  ];

in

{

  inherit options;

  config = mkIf cfg.enable {
    inherit assertions;
    programs.tsmClient.enable = true;
    programs.tsmClient.servers.${cfg.servername}.passwdDir =
      mkDefault "/var/lib/tsm-backup/password";
    systemd.services.tsm-backup = {
      description = "IBM Spectrum Protect (Tivoli Storage Manager) Backup";
      # DSM_LOG needs a trailing slash to have it treated as a directory.
      # `/var/log` would be littered with TSM log files otherwise.
      environment.DSM_LOG = "/var/log/tsm-backup/";
      # TSM needs a HOME dir to store certificates.
      environment.HOME = "/var/lib/tsm-backup";
      serviceConfig = {
        # for exit status description see
        # https://www.ibm.com/docs/en/spectrum-protect/8.1.13?topic=clients-client-return-codes
        SuccessExitStatus = "4 8";
        # The `-se` option must come after the command.
        # The `-optfile` option suppresses a `dsm.opt`-not-found warning.
        ExecStart =
          "${cfgPrg.wrappedPackage}/bin/dsmc ${cfg.command} -se='${cfg.servername}' -optfile=/dev/null";
        LogsDirectory = "tsm-backup";
        StateDirectory = "tsm-backup";
        StateDirectoryMode = "0750";
        # systemd sandboxing
        LockPersonality = true;
        NoNewPrivileges = true;
        PrivateDevices = true;
        #PrivateTmp = true;  # would break backup of {/var,}/tmp
        #PrivateUsers = true;  # would block backup of /home/*
        ProtectClock = true;
        ProtectControlGroups = true;
        ProtectHome = "read-only";
        ProtectHostname = true;
        ProtectKernelLogs = true;
        ProtectKernelModules = true;
        ProtectKernelTunables = true;
        ProtectProc = "noaccess";
        ProtectSystem = "strict";
        RestrictNamespaces = true;
        RestrictSUIDSGID = true;
      };
      startAt = mkIf (cfg.autoTime!=null) cfg.autoTime;
    };
  };

  meta.maintainers = [ lib.maintainers.yarny ];

}
