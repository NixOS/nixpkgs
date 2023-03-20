{ callPackage, makeWrapper, gobject-introspection, cmake
, python3Packages, gtk3, glib, libnotify, intltool, gnome, gdk-pixbuf, librsvg }:
let
  pkg = import ./base.nix {
    version = "3.2.5";
    pname = "gcdemu";
    pkgSha256 = "1nvpbq4mz8caw91q5ny9gf206g9bypavxws9nxyfcanfkc4zfkl4";
  };
  inherit (python3Packages) python pygobject3;
in callPackage pkg {
  buildInputs = [ python pygobject3 gtk3 glib libnotify gnome.adwaita-icon-theme gdk-pixbuf librsvg ];
  drvParams = {
    nativeBuildInputs = [ gobject-introspection cmake makeWrapper intltool ];
    postFixup = ''
      wrapProgram $out/bin/gcdemu \
        --set PYTHONPATH "$PYTHONPATH" \
        --set GI_TYPELIB_PATH "$GI_TYPELIB_PATH" \
        --prefix XDG_DATA_DIRS : "$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
    '';
    # TODO AppIndicator
  };
}
