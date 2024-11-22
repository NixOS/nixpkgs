{ config, lib, pkgs, ... }:
let
  cfg = config.services.blocky;

  format = pkgs.formats.yaml { };
  configFile = format.generate "config.yaml" cfg.settings;
in
{
  options.services.blocky = {
    enable = lib.mkEnableOption "blocky, a fast and lightweight DNS proxy as ad-blocker for local network with many features";

    package = lib.mkPackageOption pkgs "blocky" { };

    settings = lib.mkOption {
      type = format.type;
      default = { };
      description = ''
        Blocky configuration. Refer to
        <https://0xerr0r.github.io/blocky/configuration/>
        for details on supported values.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.services.blocky = {
      description = "A DNS proxy and ad-blocker for the local network";
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        DynamicUser = true;
        ExecStart = "${lib.getExe cfg.package} --config ${configFile}";
        Restart = "on-failure";

        AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
        CapabilityBoundingSet = [ "CAP_NET_BIND_SERVICE" ];
      };
    };
  };
}
