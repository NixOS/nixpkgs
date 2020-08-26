# https://github.com/atlas-engineer/next/tree/master/ports/gtk-webkit

{ stdenv
, pkg-config
, next
, webkitgtk
, gtk3
, glib
, gsettings-desktop-schemas
, glib-networking
, gst_all_1
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "next-gtk-webkit";
  inherit (next) src version;

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook
  ];

  buildInputs = [
    glib
    glib-networking
    gsettings-desktop-schemas
    gtk3
    webkitgtk
    gst_all_1.gst-plugins-base
    gst_all_1.gstreamer
  ];

  makeFlags = [
    "gtk-webkit"
    "PREFIX=${placeholder "out"}"
  ];

  installTargets =  [
    "install-gtk-webkit"
  ];

  meta = with stdenv.lib; {
    description = "Infinitely extensible web-browser (user interface only)";
    homepage = "https://next.atlas.engineer";
    license = licenses.bsd3;
    maintainers = [ maintainers.lewo ];
    platforms = [ "x86_64-linux" ];
  };
}
