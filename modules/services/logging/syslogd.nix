{ config, pkgs, ... }:

with pkgs.lib;

let

  cfg = config.services.syslogd;

  syslogConf = pkgs.writeText "syslog.conf" ''
    ${if (cfg.tty != "") then "kern.warning;*.err;authpriv.none /dev/${cfg.tty}" else ""}
    ${cfg.defaultConfig}
    ${cfg.extraConfig}
  '';

  defaultConf = ''
    # Send emergency messages to all users.
    *.emerg                       *

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

    services.syslogd = {

      tty = mkOption {
        type = types.uniq types.string;
        default = "tty10";
        description = ''
          The tty device on which syslogd will print important log
          messages. Leave this option blank to disable tty logging.
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

      enableNetworkInput = mkOption {
        type = types.bool;
        default = false;
        description = ''
          Accept logging through UDP. Option -r of syslogd(8).
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
        type = types.listOf types.string;
        default = [ ];
        example = [ "-m 0" ];
        description = ''
          Additional parameters passed to <command>syslogd</command>.
        '';
      };

    };

  };


  ###### implementation

  config = {

    services.syslogd.extraParams = optional cfg.enableNetworkInput "-r";

    jobs.syslogd =
      { description = "Syslog daemon";

        #startOn = "started udev";

        environment = { TZ = config.time.timeZone; };

        daemonType = "fork";

        path = [ pkgs.sysklogd ];

        exec = "syslogd ${toString cfg.extraParams} -f ${syslogConf}";
      };

  };

}
