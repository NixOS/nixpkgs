{ config, lib, pkgs, ... }:

let
  cfg = config.services.xserver.gdk-pixbuf;

  loadersCache = pkgs.gnome._gdkPixbufCacheBuilder_DO_NOT_USE {
    extraLoaders = lib.unique (cfg.modulePackages);
  };
in

{
  options = {
    services.xserver.gdk-pixbuf.modulePackages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [ ];
      description = lib.mdDoc "Packages providing GDK-Pixbuf modules, for cache generation.";
    };
  };

  # If there is any package configured in modulePackages, we generate the
  # loaders.cache based on that and set the environment variable
  # GDK_PIXBUF_MODULE_FILE to point to it.
  config = lib.mkIf (cfg.modulePackages != []) {
    environment.sessionVariables = {
      GDK_PIXBUF_MODULE_FILE = "${loadersCache}";
    };
  };
}
