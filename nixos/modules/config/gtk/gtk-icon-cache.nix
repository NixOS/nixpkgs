{ config, lib, pkgs, ... }:

with lib;
{
  options = {
    gtk.iconCache.enable = mkOption {
      type = types.bool;
      default = config.services.xserver.enable;
      defaultText = literalExpression "config.services.xserver.enable";
      description = lib.mdDoc ''
        Whether to build icon theme caches for GTK applications.
      '';
    };
  };

  config = mkIf config.gtk.iconCache.enable {

    # (Re)build icon theme caches
    # ---------------------------
    # Each icon theme has its own cache. The difficult is that many
    # packages may contribute with icons to the same theme by installing
    # some icons.
    #
    # For instance, on my current NixOS system, the following packages
    # (among many others) have icons installed into the hicolor icon
    # theme: hicolor-icon-theme, psensor, wpa_gui, caja, etc.
    #
    # As another example, the mate icon theme has icons installed by the
    # packages mate-icon-theme, mate-settings-daemon, and libmateweather.
    #
    # The HighContrast icon theme also has icons from different packages,
    # like gnome-theme-extras and meld.

    # When the cache is built all of its icons has to be known. How to
    # implement this?
    #
    # I think that most themes have all icons installed by only one
    # package. On my system there are 71 themes installed. Only 3 of them
    # have icons installed from more than one package.
    #
    # If the main package of the theme provides a cache, presumably most
    # of its icons will be available to applications without running this
    # module. But additional icons offered by other packages will not be
    # available. Therefore I think that it is good that the main theme
    # package installs a cache (although it does not completely fixes the
    # situation for packages installed with nix-env).
    #
    # The module solution presented here keeps the cache when there is
    # only one package contributing with icons to the theme. Otherwise it
    # rebuilds the cache taking into account the icons provided all
    # packages.

    environment.extraSetup = ''
      # For each icon theme directory ...

      find $out/share/icons -mindepth 1 -maxdepth 1 -print0 | while read -d $'\0' themedir
      do

        # In order to build the cache, the theme dir should be
        # writable. When the theme dir is a symbolic link to somewhere
        # in the nix store it is not writable and it means that only
        # one package is contributing to the theme. If it already has
        # a cache, no rebuild is needed. Otherwise a cache has to be
        # built, and to be able to do that we first remove the
        # symbolic link and make a directory, and then make symbolic
        # links from the original directory into the new one.

        if [ ! -w "$themedir" -a -L "$themedir" -a ! -r "$themedir"/icon-theme.cache ]; then
          name=$(basename "$themedir")
          path=$(readlink -f "$themedir")
          rm "$themedir"
          mkdir -p "$themedir"
          ln -s "$path"/* "$themedir"/
        fi

        # (Re)build the cache if the theme dir is writable, replacing any
        # existing cache for the theme

        if [ -w "$themedir" ]; then
          rm -f "$themedir"/icon-theme.cache
          ${pkgs.buildPackages.gtk3.out}/bin/gtk-update-icon-cache --ignore-theme-index "$themedir"
        fi
      done
    '';
  };

}
