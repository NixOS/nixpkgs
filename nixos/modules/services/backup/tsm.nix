{ config, lib, ... }:

let

  inherit (lib.attrsets) hasAttr;
  inherit (lib.modules) mkDefault mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) nullOr strMatching;

  options.services.tsmBackup = {
    enable = mkEnableOption ''
      automatic backups with the
      IBM Spectrum Protect (Tivoli Storage Manager, TSM) client.
      This also enables
      <option>programs.tsmClient.enable</option>
    '';
    command = mkOption {
      type = strMatching ".+";
      default = "backup";
      example = "incr";
      description = ''
        The actual command passed to the
        <literal>dsmc</literal> executable to start the backup.
      '';
    };
    servername = mkOption {
      type = strMatching ".+";
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
      type = nullOr (strMatching ".+");
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
    programs.tsmClient.servers."${cfg.servername}".passwdDir =
      mkDefault "/var/lib/tsm-backup/password";
    systemd.services.tsm-backup = {
      description = "IBM Spectrum Protect (Tivoli Storage Manager) Backup";
      # DSM_LOG needs a trailing slash to have it treated as a directory.
      # `/var/log` would be littered with TSM log files otherwise.
      environment.DSM_LOG = "/var/log/tsm-backup/";
      # TSM needs a HOME dir to store certificates.
      environment.HOME = "/var/lib/tsm-backup";
      # for exit status description see
      # https://www.ibm.com/support/knowledgecenter/en/SSEQVQ_8.1.8/client/c_sched_rtncode.html
      serviceConfig.SuccessExitStatus = "4 8";
      # The `-se` option must come after the command.
      # The `-optfile` option suppresses a `dsm.opt`-not-found warning.
      serviceConfig.ExecStart =
        "${cfgPrg.wrappedPackage}/bin/dsmc ${cfg.command} -se='${cfg.servername}' -optfile=/dev/null";
      serviceConfig.LogsDirectory = "tsm-backup";
      serviceConfig.StateDirectory = "tsm-backup";
      serviceConfig.StateDirectoryMode = "0750";
      startAt = mkIf (cfg.autoTime!=null) cfg.autoTime;
    };
  };

  meta.maintainers = [ lib.maintainers.yarny ];

}
