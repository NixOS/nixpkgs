{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.act;
in
{
  options.programs.act = {
    enable = lib.mkEnableOption "act";
    package = lib.mkPackageOption pkgs "act" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];

    virtualisation.podman = lib.mkIf (!config.virtualisation.docker.enable) {
      enable = true;
      dockerSocket.enable = true;
    };
  };

  meta.maintainers = with lib.maintainers; [ yiyu ];
}
