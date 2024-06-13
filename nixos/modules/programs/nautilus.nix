{ config, pkgs, lib, ... }:

let
  cfg = config.programs.nautilus;
  package = pkgs.nautilus;
in

{
  meta = {
    maintainers = pkgs.nautilus.meta.members;
  };

  options = {
    programs.nautilus = {
      enable = lib.mkEnableOption "Nautilus file manager";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [ package ];
    services.dbus.packages = [ package ];

    # Let nautilus find extensions
    # TODO: Create nautilus-with-extensions package
    environment.sessionVariables.NAUTILUS_4_EXTENSION_DIR = "${config.system.path}/lib/nautilus/extensions-4";

    environment.pathsToLink = [
      "/share/nautilus-python/extensions"
    ];
  };
}
