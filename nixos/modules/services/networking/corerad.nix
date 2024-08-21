{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.corerad;
  settingsFormat = pkgs.formats.toml {};

in {
  meta.maintainers = with maintainers; [ mdlayher ];

  options.services.corerad = {
    enable = mkEnableOption "CoreRAD IPv6 NDP RA daemon";

    settings = mkOption {
      type = settingsFormat.type;
      example = literalExpression ''
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
        Configuration for CoreRAD, see <https://github.com/mdlayher/corerad/blob/main/internal/config/reference.toml>
        for supported values. Ignored if configFile is set.
      '';
    };

    configFile = mkOption {
      type = types.path;
      example = literalExpression ''"''${pkgs.corerad}/etc/corerad/corerad.toml"'';
      description = "Path to CoreRAD TOML configuration file.";
    };

    package = mkPackageOption pkgs "corerad" { };
  };

  config = mkIf cfg.enable {
    # Prefer the config file over settings if both are set.
    services.corerad.configFile = mkDefault (settingsFormat.generate "corerad.toml" cfg.settings);

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
        RestartKillSignal = "SIGHUP";
      };
    };
  };
}
