{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.corerad;

  writeTOML = name: x:
    pkgs.runCommandNoCCLocal name {
      passAsFile = ["config"];
      config = builtins.toJSON x;
      buildInputs = [ pkgs.go-toml ];
    } "jsontoml < $configPath > $out";

in {
  meta.maintainers = with maintainers; [ mdlayher ];

  options.services.corerad = {
    enable = mkEnableOption "CoreRAD IPv6 NDP RA daemon";

    settings = mkOption {
      type = types.uniq types.attrs;
      example = literalExample ''
        {
          interfaces = [
            # eth0 is an upstream interface monitoring for IPv6 router advertisements.
            {
              name = "eth0";
              monitor = true;
            }
            # eth1 is a downstream interface advertising IPv6 prefixes for SLAAC.
            {
              name = "eth1";
              advertise = true;
              prefix = [{ prefix = "::/64"; }];
            }
          ];
          # Optionally enable Prometheus metrics.
          debug = {
            address = "localhost:9430";
            prometheus = true;
          };
        }
      '';
      description = ''
        Configuration for CoreRAD, see <link xlink:href="https://github.com/mdlayher/corerad/blob/master/internal/config/default.toml"/>
        for supported values. Ignored if configFile is set.
      '';
    };

    configFile = mkOption {
      type = types.path;
      example = literalExample "\"\${pkgs.corerad}/etc/corerad/corerad.toml\"";
      description = "Path to CoreRAD TOML configuration file.";
    };

    package = mkOption {
      default = pkgs.corerad;
      defaultText = literalExample "pkgs.corerad";
      type = types.package;
      description = "CoreRAD package to use.";
    };
  };

  config = mkIf cfg.enable {
    # Prefer the config file over settings if both are set.
    services.corerad.configFile = mkDefault (writeTOML "corerad.toml" cfg.settings);

    systemd.services.corerad = {
      description = "CoreRAD IPv6 NDP RA daemon";
      after = [ "network.target" ];
      wantedBy = [ "multi-user.target" ];
      serviceConfig = {
        LimitNPROC = 512;
        LimitNOFILE = 1048576;
        CapabilityBoundingSet = "CAP_NET_ADMIN CAP_NET_RAW";
        AmbientCapabilities = "CAP_NET_ADMIN CAP_NET_RAW";
        NoNewPrivileges = true;
        DynamicUser = true;
        Type = "notify";
        NotifyAccess = "main";
        ExecStart = "${getBin cfg.package}/bin/corerad -c=${cfg.configFile}";
        Restart = "on-failure";
      };
    };
  };
}
