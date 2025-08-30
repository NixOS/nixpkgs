{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.uv;
in
{
  options.programs.uv = {
    enable = lib.mkEnableOption "uv";
    package = lib.mkPackageOption pkgs "uv" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    programs.nix-ld.enable = true;
  };

  meta.maintainers = with lib.maintainers; [ yiyu ];
}
