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
    systemd.packages = [ cfg.package ];
    services.gnome.at-spi2-core.enable = true;
    services.speechd.enable = true;
  };
}
