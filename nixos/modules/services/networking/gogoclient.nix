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
          Enable the gogoCLIENT IPv6 tunnel.
        '';
      };
      autorun = mkOption {
        default = true;
        description = ''
          Whether to automatically start the tunnel.
        '';
      };

      username = mkOption {
        default = "";
        description = ''
          Your Gateway6 login name, if any.
        '';
      };

      password = mkOption {
        default = "";
        type = types.string;
        description = ''
          Path to a file (as a string), containing your gogoNET password, if any.
        '';
      };

      server = mkOption {
        default = "anonymous.freenet6.net";
        example = "broker.freenet6.net";
        description = "The Gateway6 server to be used.";
      };
    };
  };

  ###### implementation

  config = mkIf cfg.enable {
    boot.kernelModules = [ "tun" ];

    networking.enableIPv6 = true;

    systemd.services.gogoclient = {
      description = "ipv6 tunnel";

      after = [ "network.target" ];
      requires = [ "network.target" ];

      unitConfig.RequiresMountsFor = "/var/lib/gogoc";

      script = let authMethod = if cfg.password == "" then "anonymous" else "any"; in ''
        mkdir -p -m 700 /var/lib/gogoc
        cat ${pkgs.gogoclient}/share/${pkgs.gogoclient.name}/gogoc.conf.sample | \
          ${pkgs.gnused}/bin/sed \
            -e "s|^userid=|&${cfg.username}|" \
            -e "s|^passwd=|&${optionalString (cfg.password != "") "$(cat ${cfg.password})"}|" \
            -e "s|^server=.*|server=${cfg.server}|" \
            -e "s|^auth_method=.*|auth_method=${authMethod}|" \
            -e "s|^#log_file=|log_file=1|" > /var/lib/gogoc/gogoc.conf
        cd /var/lib/gogoc
        exec ${pkgs.gogoclient}/bin/gogoc -y -f /var/lib/gogoc/gogoc.conf
      '';
    } // optionalAttrs cfg.autorun {
      wantedBy = [ "ip-up.target" ];
      partOf = [ "ip-up.target" ];
    };

  };

}
