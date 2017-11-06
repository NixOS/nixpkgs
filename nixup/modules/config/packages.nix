{ config, lib, pkgs, ... }:

with lib;

let

  userPath = pkgs.buildEnv {
    name = "user-path";
    paths = config.user.packages;
    pathsToLink = config.user.pathsToLink;
    ignoreCollisions = true;
    # !!! Hacky, should modularise.
    postBuild =
      ''
        if [ -x $out/bin/update-mime-database -a -w $out/share/mime/packages ]; then
            XDG_DATA_DIRS=$out/share $out/bin/update-mime-database -V $out/share/mime > /dev/null
        fi

        if [ -x $out/bin/gtk-update-icon-cache -a -f $out/share/icons/hicolor/index.theme ]; then
            $out/bin/gtk-update-icon-cache $out/share/icons/hicolor
        fi

        if [ -x $out/bin/glib-compile-schemas -a -w $out/share/glib-2.0/schemas ]; then
            $out/bin/glib-compile-schemas $out/share/glib-2.0/schemas
        fi

        if [ -x $out/bin/update-desktop-database -a -w $out/share/applications ]; then
            $out/bin/update-desktop-database $out/share/applications
        fi
      '';
  };

in

{

  options = {

    user.packages = mkOption {
      default = [];
      type = types.listOf types.path;
      example = literalExample "with config.nixpkgs.pkgs; [ firefox thunderbird ]";
      description = ''
        The set of packages that appear in
        <filename>$XDG_RUNTIME_DIR/nixup/active-profile/sw</filename>. These packages are
        automatically updated every time you rebuild the user profile.
      '';
    };

    user.pathsToLink = mkOption {
      type = types.listOf types.str;
      default = [
        "/bin"
        "/etc/xdg"
        "/info"
        "/man"
        "/sbin"
        "/share/emacs"
        "/share/vim-plugins"
        "/share/org"
        "/share/info"
        "/share/terminfo"
        "/share/man"
      ];
      example = ["/"];
      description = ''
        List of directories to be symlinked in <filename>$XDG_RUNTIME_DIR/nixup/active-profile/sw</filename>.
      '';
    };

  };

  config = {
    nixup.build.userPath = userPath;
    nixup.buildCommands = ''
      ln -s ${userPath} $out/sw
    '';
  };
}
