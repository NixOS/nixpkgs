{ callPackage, makeWrapper, gobject-introspection, cmake
, python3Packages, gtk3, glib, libxml2, gnuplot, gnome, gdk-pixbuf, librsvg, intltool, libmirage }:
let pkg = import ./base.nix {
  version = "3.2.5";
  pname = "image-analyzer";
  pkgSha256 = "00906lky0z1m0bdqnjmzxgcb19dzvljhddhh42lixyr53sjp94cc";
};
in callPackage pkg {
  buildInputs = [ glib gtk3 libxml2 gnuplot libmirage gnome.adwaita-icon-theme gdk-pixbuf librsvg
                  python3Packages.python python3Packages.pygobject3 python3Packages.matplotlib ];
  drvParams = {
    nativeBuildInputs = [ gobject-introspection cmake makeWrapper intltool ];
    postFixup = ''
      wrapProgram $out/bin/image-analyzer \
        --set PYTHONPATH "$PYTHONPATH" \
        --set GI_TYPELIB_PATH "$GI_TYPELIB_PATH" \
        --prefix XDG_DATA_DIRS : "$out/share:$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH"
    '';
  };
}
