{pkgs, config, ...}:

with pkgs.lib;

let cfg = config.services.gogoclient;
in

{

  ###### interface

  options = {
    services.gogoclient = {
      enable = mkOption {
        default = false;
        type =  types.bool;
        description = ''
          Enable the gogoclient ipv6 tunnel.
        '';
      };
      autorun = mkOption {
        default = true;
        description = "
          Switch to false to create upstart-job and configuration,
          but not run it automatically
        ";
      };

      username = mkOption {
        default = "";
        description = "
          Your Gateway6 login name, if any.
        ";
      };

      password = mkOption {
        default = "";
        type = types.string;
        description = "
          Path to a file (as a string), containing your gogonet password, if any.
        ";
      };

      server = mkOption {
        default = "anonymous.freenet6.net";
        example = "broker.freenet6.net";
        description = "
          Used Gateway6 server.
        ";
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    boot.kernelModules = [ "tun" ];

    # environment.systemPackages = [pkgs.gogoclient];

    networking.enableIPv6 = true;

    jobs.gogoclient = {
      name = "gogoclient";
      description = "ipv6 tunnel";
      startOn = optionalString cfg.autorun "starting networking";
      stopOn = "stopping network-interfaces";
      preStart = ''
        mkdir -p /var/lib/gogoc
        chmod 700 /var/lib/gogoc
        cat ${pkgs.gogoclient}/share/${pkgs.gogoclient.name}/gogoc.conf.sample | ${pkgs.gnused}/bin/sed -e "s|^userid=|&${cfg.username}|;s|^passwd=|&${if cfg.password == "" then "" else "$(cat ${cfg.password})"}|;s|^server=.*|server=${cfg.server}|;s|^auth_method=.*|auth_method=${if cfg.password == "" then "anonymous" else "any"}|;s|^#log_file=|log_file=1|" > /var/lib/gogoc/gogoc.conf
      '';
      script = "cd /var/lib/gogoc; exec gogoc -y -f ./gogoc.conf";
      path = [pkgs.gogoclient];
    };

  };

}
