{ config, pkgs, ... }:

with pkgs.lib;

let

  syslogConf = pkgs.writeText "syslog.conf" ''
    kern.warning;*.err;authpriv.none /dev/${config.services.syslogd.tty}

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
        default = "tty10";
        description = ''
          The tty device on which syslogd will print important log
          messages.
        '';
      };
      
    };
    
  };


  ###### implementation

  config = {
  
    jobs.syslogd =
      { description = "Syslog daemon";

        startOn = "started udev";

        environment = { TZ = config.time.timeZone; };

        daemonType = "fork";

        exec = "${pkgs.sysklogd}/sbin/syslogd -f ${syslogConf}";
      };

  };
  
}
