{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.corerad;
  settingsFormat = pkgs.formats.toml { };

in
{
  meta.maintainers = with lib.maintainers; [ mdlayher ];

  options.services.corerad = {
    enable = lib.mkEnableOption "CoreRAD IPv6 NDP RA daemon";

    settings = lib.mkOption {
      type = settingsFormat.type;
      example = lib.literalExpression ''
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

    configFile = lib.mkOption {
      type = lib.types.path;
      example = lib.literalExpression ''"''${pkgs.corerad}/etc/corerad/corerad.toml"'';
      description = "Path to CoreRAD TOML configuration file.";
    };

    package = lib.mkPackageOption pkgs "corerad" { };
  };

  config = lib.mkIf cfg.enable {
    # Prefer the config file over settings if both are set.
    services.corerad.configFile = lib.mkDefault (settingsFormat.generate "corerad.toml" cfg.settings);

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
        ExecStart = "${lib.getBin cfg.package}/bin/corerad -c=${cfg.configFile}";
        Restart = "on-failure";
        RestartKillSignal = "SIGHUP";
      };
    };
  };
}
