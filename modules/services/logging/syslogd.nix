{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

  options = {
    services = {

      syslogd = {

        tty = mkOption {
          default = 10;
          description = "
            The tty device on which syslogd will print important log
            messages.
          ";
        };
      
      };
    };
  };
in

###### implementation

let

  syslogConf = pkgs.writeText "syslog.conf" ''
    kern.warning;*.err;authpriv.none /dev/tty10

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
  require = [
    options
  ];

  services = {
    extraJobs = [{
        name = "syslogd";
        
        job = ''
          description "Syslog daemon"
        
          start on udev
          stop on shutdown

          env TZ=${config.time.timeZone}
          
          respawn ${pkgs.sysklogd}/sbin/syslogd -n -f ${syslogConf}
        '';
    }];
  };
}
