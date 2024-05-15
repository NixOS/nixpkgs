{ stdenv, cmake, pkg-config, callPackage, makeWrapper, gobject-introspection, wrapGAppsHook3
, python3Packages, gtk3, glib, libxml2, gnuplot, gnome, gdk-pixbuf, librsvg, intltool, libmirage }:
stdenv.mkDerivation {

  inherit (callPackage ./common-drv-attrs.nix {
    version = "3.2.6";
    pname = "image-analyzer";
    hash = "sha256-7I8RUgd+k3cEzskJGbziv1f0/eo5QQXn62wGh/Y5ozc=";
  }) pname version src meta;

  buildInputs = [ libxml2 gnuplot libmirage gnome.adwaita-icon-theme gdk-pixbuf librsvg
                  python3Packages.pygobject3 python3Packages.matplotlib ];
  nativeBuildInputs = [ cmake pkg-config wrapGAppsHook3 intltool ];

  dontWrapGApps = true;
  postFixup = ''
    wrapProgram $out/bin/image-analyzer \
      ''${gappsWrapperArgs[@]} \
      --set PYTHONPATH "$PYTHONPATH"
  '';
}
