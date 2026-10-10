{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.programs.nix-software;
in
{
  options.programs.nix-software = {
    enable = lib.mkEnableOption "Nix Software, a declarative app store for NixOS and Home Manager";
    package = lib.mkPackageOption pkgs "nix-software" { };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ cfg.package ];
    # Applying asks for administrator rights through polkit.
    security.polkit.enable = true;
    # GNOME Shell finds the search provider here.
    environment.pathsToLink = [ "/share/gnome-shell/search-providers" ];
    services.dbus.packages = [ cfg.package ];
  };

  meta.maintainers = with lib.maintainers; [ SPTApyo ];
}
