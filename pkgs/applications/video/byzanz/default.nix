{ lib, stdenv
, fetchgit
, wrapGAppsHook3
, cairo
, glib
, gnome-common
, gst_all_1
, gtk3
, intltool
, libtool
, pkg-config
, which
, xorg
}:

stdenv.mkDerivation {
  pname = "byzanz";
  version = "unstable-2016-03-12";

  src = fetchgit {
    url = "https://gitlab.gnome.org/Archive/byzanz";
    rev = "81235d235d12c9687897f7fc6ec0de1feaed6623";
    hash = "sha256-3DUwXCPBAmeCRlDkiPUgwNyBa6bCvC/TLguMCK3bo4E=";
  };

  patches = [ ./add-amflags.patch ];

  preBuild = ''
    ./autogen.sh --prefix=$out
  '';

  env.NIX_CFLAGS_COMPILE = builtins.concatStringsSep " " [
    "-Wno-error=deprecated-declarations"
    "-Wno-error=incompatible-pointer-types"
  ];

  nativeBuildInputs = [ pkg-config intltool ];
  buildInputs = [
    which
    gnome-common
    glib
    libtool
    cairo
    gtk3
    xorg.xwininfo
    xorg.libXdamage
  ] ++ (with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-bad
    gst-plugins-good
    gst-plugins-ugly
    gst-libav
    wrapGAppsHook3
  ]);

  meta = with lib; {
    description = "Tool to record a running X desktop to an animation suitable for presentation in a web browser";
    homepage = "https://github.com/GNOME/byzanz";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
