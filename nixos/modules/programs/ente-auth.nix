{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.programs.ente-auth;
in
{
  options.programs.ente-auth = {
    enable = lib.mkEnableOption "Ente Auth";
    package = lib.mkPackageOption pkgs "ente-auth" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    services.gnome.gnome-keyring.enable = true;
  };

  meta.maintainers = with lib.maintainers; [ yiyu ];
}
