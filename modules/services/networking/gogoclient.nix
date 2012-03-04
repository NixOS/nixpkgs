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

    networking = {
      enableIPv6 = true;
      interfaceJobs = optional cfg.autorun config.jobs.gogoclient;
    };

    jobs.gogoclient = {
      name = "gogoclient";
      description = "ipv6 tunnel";
      startOn = if cfg.autorun then "started network-interfaces" else "";
      stopOn = "stopping network-interfaces";
      script = "cd /var/lib/gogoc; exec gogoc -y -f /etc/gogoc.conf";
      path = [pkgs.gogoclient];
    };

    system.activationScripts.gogoClientConf = ''
      mkdir -p /var/lib/gogoc
      chmod 700 /var/lib/gogoc
      install -m400 ${pkgs.gogoclient}/share/${pkgs.gogoclient.name}/gogoc.conf.sample /etc/gogoc.conf.default
      ${pkgs.gnused}/bin/sed -i -e "s|^userid=|&${cfg.username}|" /etc/gogoc.conf.default
      ${pkgs.gnused}/bin/sed -i -e "s|^passwd=|&${if cfg.password == "" then "" else "$(cat ${cfg.password})"}|" /etc/gogoc.conf.default
      ${pkgs.gnused}/bin/sed -i -e "s|^server=.*|server=${cfg.server}|" /etc/gogoc.conf.default
      ${pkgs.gnused}/bin/sed -i -e "s|^auth_method=.*|auth_method=${if cfg.password == "" then "anonymous" else "any"}|" /etc/gogoc.conf.default
      ${pkgs.gnused}/bin/sed -i -e "s|^#log_file=|log_file=1|" /etc/gogoc.conf.default
      mv /etc/gogoc.conf.default /etc/gogoc.conf
    '';
  };

}
