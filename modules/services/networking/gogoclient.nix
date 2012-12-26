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

    networking.enableIPv6 = true;

    boot.systemd.services.gogoclient = {

      description = "ipv6 tunnel";

      after = [ "network.target" ];

      preStart = let authMethod = if cfg.password == "" then "anonymous" else "any"; in
      ''
        mkdir -p -m 700 /var/lib/gogoc
        cat ${pkgs.gogoclient}/share/${pkgs.gogoclient.name}/gogoc.conf.sample | \
          ${pkgs.gnused}/bin/sed \
            -e "s|^userid=|&${cfg.username}|" \
            -e "s|^passwd=|&${optionalString (cfg.password != "") "$(cat ${cfg.password})"}|" \
            -e "s|^server=.*|server=${cfg.server}|" \
            -e "s|^auth_method=.*|auth_method=${authMethod}|" \
            -e "s|^#log_file=|log_file=1|" > /var/lib/gogoc/gogoc.conf
      '';

      serviceConfig.ExecStart = "${pkgs.gogoclient}/bin/gogoc -y -f /var/lib/gogoc/gogoc.conf";

      restartTriggers = attrValues cfg;

    } // optionalAttrs cfg.autorun {

      wantedBy = [ "ip-up.target" ];

      partOf = [ "ip-up.target" ];

    };

  };

}
