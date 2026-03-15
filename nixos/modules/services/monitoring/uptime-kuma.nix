{
  config,
  pkgs,
  lib,
  ...
}:

let
  cfg = config.services.uptime-kuma;
in
{
  imports =
    map
      (
        opt:
        lib.mkAliasOptionModule
          [ "services" "uptime-kuma" opt ]
          [ "system" "services" "uptime-kuma" "uptime-kuma" opt ]
      )
      [
        "package"
        "appriseSupport"
        "settings"
      ];

  options = {
    services.uptime-kuma = {
      enable = lib.mkEnableOption "Uptime Kuma, this assumes a reverse proxy to be set";
    };
  };

  config = lib.mkIf cfg.enable {
    system.services.uptime-kuma = {
      imports = [ pkgs.uptime-kuma.services.default ];
    };
  };

  meta.maintainers = with lib.maintainers; [
    james-1701
    julienmalka
  ];
}
