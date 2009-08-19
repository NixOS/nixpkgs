{pkgs, config, ...}:

###### interface
let
  inherit (pkgs.lib) mkOption mkIf;

  options = {
    services = {
      xinetd = {
        enable = mkOption {
          default = false;
          description = "
            Whether to enable the vsftpd FTP server.
          ";
        };

        tftpd = {
          enable = mkOption {
            default = false;
            description = "
              Whether to enable the anonymous FTP user.
            ";
          };

          path = mkOption {
            default = "/home/tftp";
            description = "
              Where the tftp server files are stored
            ";
          };
        };
      };
    };
  };
in

###### implementation

let 

  inherit (config.services.xinetd) tftpd;
  inherit (pkgs) xinetd;

  tftpservice = ''
    service tftp
    {
       protocol = udp
       port = 69
       socket_type = dgram
       wait = yes
       user = nobody
       server = ${pkgs.netkittftp}/sbin/in.tftpd
       server_args = ${tftpd.path}
       disable = no
    }
  '';

  configFile = pkgs.writeText "xinetd.conf" ''
    defaults
    {
      log_type = SYSLOG daemon info
      log_on_failure = HOST
      log_on_success = PID HOST DURATION EXIT
    }
    ${if tftpd.enable then tftpservice else ""}
  '';

in

mkIf config.services.xinetd.enable {
  require = [
    options
  ];

  services = {
    extraJobs = [{
      name = "xinetd";

      job = ''
        description "xinetd server"

        start on network-interfaces/started
        stop on network-interfaces/stop

        start script

        mkdir -p ${tftpd.path}
        end script

        respawn ${xinetd}/sbin/xinetd -stayalive -f ${configFile}
      '';
      
    }];
  };
}
