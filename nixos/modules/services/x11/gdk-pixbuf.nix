{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.xserver.gdk-pixbuf;

  # Get packages to generate the cache for. We always include gdk-pixbuf.
  effectivePackages = unique ([pkgs.gdk-pixbuf] ++ cfg.modulePackages);

  # Generate the cache file by running gdk-pixbuf-query-loaders for each
  # package and concatenating the results.
  loadersCache = pkgs.runCommand "gdk-pixbuf-loaders.cache" { preferLocalBuild = true; } ''
    (
      for package in ${concatStringsSep " " effectivePackages}; do
        module_dir="$package/${pkgs.gdk-pixbuf.moduleDir}"
        if [[ ! -d $module_dir ]]; then
          echo "Warning (services.xserver.gdk-pixbuf): missing module directory $module_dir" 1>&2
          continue
        fi
        GDK_PIXBUF_MODULEDIR="$module_dir" \
          ${pkgs.stdenv.hostPlatform.emulator pkgs.buildPackages} ${pkgs.gdk-pixbuf.dev}/bin/gdk-pixbuf-query-loaders
      done
    ) > "$out"
  '';
in

{
  options = {
    services.xserver.gdk-pixbuf.modulePackages = mkOption {
      type = types.listOf types.package;
      default = [ ];
      description = lib.mdDoc "Packages providing GDK-Pixbuf modules, for cache generation.";
    };
  };

  # If there is any package configured in modulePackages, we generate the
  # loaders.cache based on that and set the environment variable
  # GDK_PIXBUF_MODULE_FILE to point to it.
  config = mkIf (cfg.modulePackages != []) {
    environment.variables = {
      GDK_PIXBUF_MODULE_FILE = "${loadersCache}";
    };
  };
}
