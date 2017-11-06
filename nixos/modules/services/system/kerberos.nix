{pkgs, config, lib, ...}:

let
  inherit (lib) mkOption mkIf;
  cfg = config.services.kerberos_server;
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

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.heimdalFull ];
    systemd.services.kadmind = {
      description = "Kerberos Administration Daemon";
      script = "${pkgs.heimdalFull}/libexec/heimdal/kadmind";
    };

    systemd.services.kdc = {
      description = "Key Distribution Center daemon";
      wantedBy = [ "multi-user.target" ];
      preStart = ''
        mkdir -m 0755 -p ${stateDir}
      '';
      script = "${pkgs.heimdalFull}/libexec/heimdal/kdc";
    };

    systemd.services.kpasswdd = {
      description = "Kerberos Password Changing daemon";
      wantedBy = [ "multi-user.target" ];
      script = "${pkgs.heimdalFull}/libexec/heimdal/kpasswdd";
    };
  };
}
