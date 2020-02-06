{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.corerad;
in {
  meta = {
    maintainers = with maintainers; [ mdlayher ];
  };

  options.services.corerad = {
    enable = mkEnableOption "CoreRAD IPv6 NDP RA daemon";

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
        ExecStart = "${getBin cfg.package}/bin/corerad -c=${cfg.configFile}";
        Restart = "on-failure";
      };
    };
  };
}
