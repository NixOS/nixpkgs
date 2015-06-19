{ config, lib, pkgs, ... }:

with lib;

let

  cfg = config.services.rsyslogd;

  syslogConf = pkgs.writeText "syslog.conf" ''
    $ModLoad imuxsock
    $SystemLogSocketName /run/systemd/journal/syslog
    $WorkDirectory /var/spool/rsyslog

    ${cfg.defaultConfig}
    ${cfg.extraConfig}
  '';

  defaultConf = ''
    # "local1" is used for dhcpd messages.
    local1.*                     -/var/log/dhcpd

    mail.*                       -/var/log/mail

    *.=warning;*.=err            -/var/log/warn
    *.crit                        /var/log/warn

    *.*;mail.none;local1.none    -/var/log/messages
  '';

in

{
  ###### interface

  options = {

    services.rsyslogd = {

      enable = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Whether to enable syslogd.  Note that systemd also logs
          syslog messages, so you normally don't need to run syslogd.
        '';
      };

      defaultConfig = mkOption {
        type = types.string;
        default = defaultConf;
        description = ''
          The default <filename>syslog.conf</filename> file configures a
          fairly standard setup of log files, which can be extended by
          means of <varname>extraConfig</varname>.
        '';
      };

      extraConfig = mkOption {
        type = types.string;
        default = "";
        example = "news.* -/var/log/news";
        description = ''
          Additional text appended to <filename>syslog.conf</filename>,
          i.e. the contents of <varname>defaultConfig</varname>.
        '';
      };

      extraParams = mkOption {
        type = types.listOf types.str;
        default = [ ];
        example = [ "-m 0" ];
        description = ''
          Additional parameters passed to <command>rsyslogd</command>.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf cfg.enable {

    environment.systemPackages = [ pkgs.rsyslog ];

    systemd.services.syslog =
      { description = "Syslog Daemon";

        requires = [ "syslog.socket" ];

        wantedBy = [ "multi-user.target" ];

        serviceConfig =
          { ExecStart = "${pkgs.rsyslog}/sbin/rsyslogd ${toString cfg.extraParams} -f ${syslogConf} -n";
            ExecStartPre = "${pkgs.coreutils}/bin/mkdir -p /var/spool/rsyslog";
            # Prevent syslogd output looping back through journald.
            StandardOutput = "null";
          };
      };

  };

}
