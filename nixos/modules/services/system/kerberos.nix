{pkgs, config, lib, ...}:

let

  inherit (lib) mkOption mkIf singleton;

  inherit (pkgs) heimdalFull;

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

    environment.systemPackages = [ heimdalFull ];

    services.xinetd.enable = true;
    services.xinetd.services = lib.singleton
      { name = "kerberos-adm";
        flags = "REUSE NAMEINARGS";
        protocol = "tcp";
        user = "root";
        server = "${pkgs.tcp_wrappers}/sbin/tcpd";
        serverArgs = "${pkgs.heimdalFull}/sbin/kadmind";
      };

    systemd.services.kdc = {
      description = "Kerberos Domain Controller daemon";
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -m 0755 -p ${stateDir}
      '';
      script = "${heimdalFull}/sbin/kdc";
    };

    systemd.services.kpasswdd = {
      description = "Kerberos Domain Controller daemon";
      wantedBy = [ "multi-user.target" ];
      script = "${heimdalFull}/sbin/kpasswdd";
    };
  };

}
