{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.services.orca;
  inherit (lib)
    mkEnableOption
    mkIf
    mkPackageOption
    ;
in
{
  options.services.orca = {
    enable = lib.mkEnableOption "Orca screen reader";
    package = lib.mkPackageOption pkgs "orca" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.speechd.enable = true;
  };
}
