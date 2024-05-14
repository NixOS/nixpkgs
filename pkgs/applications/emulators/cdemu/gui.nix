{ callPackage, makeWrapper, gobject-introspection, cmake, wrapGAppsHook3
, python3Packages, gtk3, glib, libnotify, intltool, gnome, gdk-pixbuf, librsvg }:
callPackage ./base.nix {
  version = "3.2.6";
  pname = "gcdemu";
  sha256 = "sha256-w4vzKoSotL5Cjfr4Cu4YhNSWXJqS+n/vySrwvbhR1zA=";
  buildInputs = [ python3Packages.pygobject3 gtk3 glib libnotify gnome.adwaita-icon-theme gdk-pixbuf librsvg ];
  nativeBuildInputs = [ cmake wrapGAppsHook3 intltool ];
  postFixup = ''
    wrapProgram $out/bin/gcdemu \
      --set PYTHONPATH "$PYTHONPATH"
  '';
}
