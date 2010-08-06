{pkgs, config, ...}:

let

  inherit (pkgs.lib) mkOption mkIf singleton;

  inherit (pkgs) heimdal;

  stateDir = "/var/heimdal";
in

{

  ###### interface
  
  options = {
  
    services.kerberos_server = {

      enable = mkOption {
        default = false;
        description = ''
          Enable the kerberos authentification server.
        '';
      };

    };

  };


  ###### implementation

  config = mkIf config.services.kerberos_server.enable {
  
    environment.systemPackages = [ heimdal ];
  
    services.xinetd.enable = true;
    services.xinetd.services = pkgs.lib.singleton
      { name = "kerberos-adm";
        flags = "REUSE NAMEINARGS";
        protocol = "tcp";
        user = "root";
        server = "${pkgs.tcpWrapper}/sbin/tcpd";
        serverArgs = "${pkgs.heimdal}/sbin/kadmind";
      };

    jobs.kdc =
      { description = "Kerberos Domain Controller daemon";

        startOn = "ip-up";

        preStart =
          ''
            mkdir -m 0755 -p ${stateDir}
          '';

        exec = "${heimdal}/sbin/kdc";

      };

    jobs.kpasswdd =
      { description = "Kerberos Domain Controller daemon";

        startOn = "ip-up";

        exec = "${heimdal}/sbin/kpasswdd";
      };
  };
  
}
