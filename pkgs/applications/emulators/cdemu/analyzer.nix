{ callPackage, makeWrapper, gobject-introspection, cmake, wrapGAppsHook3
, python3Packages, gtk3, glib, libxml2, gnuplot, gnome, gdk-pixbuf, librsvg, intltool, libmirage }:
callPackage ./base.nix {
  version = "3.2.6";
  pname = "image-analyzer";
  sha256 = "sha256-7I8RUgd+k3cEzskJGbziv1f0/eo5QQXn62wGh/Y5ozc=";
  buildInputs = [ glib gtk3 libxml2 gnuplot libmirage gnome.adwaita-icon-theme gdk-pixbuf librsvg
                  python3Packages.pygobject3 python3Packages.matplotlib ];
  nativeBuildInputs = [ gobject-introspection cmake wrapGAppsHook3 intltool ];
  postFixup = ''
    wrapProgram $out/bin/image-analyzer \
      --set PYTHONPATH "$PYTHONPATH"
  '';
}
