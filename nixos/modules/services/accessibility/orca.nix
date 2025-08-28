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
    enable = mkEnableOption "Orca screen reader";
    package = mkPackageOption pkgs "orca" { };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    systemd.services.display-manager = lib.mkIf config.services.displayManager.enable {
      path = [ cfg.package ];
    };
    services.speechd.enable = true;
  };
}
