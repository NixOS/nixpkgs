{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.blocky;

  format = pkgs.formats.yaml { };
  configFile = format.generate "config.yaml" cfg.settings;
in
{
  options.services.blocky = {
    enable = mkEnableOption (lib.mdDoc "Fast and lightweight DNS proxy as ad-blocker for local network with many features");

    settings = mkOption {
      type = format.type;
      default = { };
      description = lib.mdDoc ''
        Blocky configuration. Refer to
        <https://0xerr0r.github.io/blocky/configuration/>
        for details on supported values.
      '';
    };
  };

  config = mkIf cfg.enable {
    systemd.services.blocky = {
      description = "A DNS proxy and ad-blocker for the local network";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${pkgs.blocky}/bin/blocky --config ${configFile}";

        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
      };
    };
  };
}
