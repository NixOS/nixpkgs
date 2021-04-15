{ lib, stdenv, fetchgit, wrapGAppsHook, which, gnome3, glib, intltool, pkg-config, libtool, cairo, gtk3, gst_all_1, xorg }:

stdenv.mkDerivation {
  version = "0.2.3.alpha";
  pname = "byzanz";

  src = fetchgit {
    url = "git://github.com/GNOME/byzanz";
    rev = "1875a7f6a3903b83f6b1d666965800f47db9286a";
    sha256 = "0a72fw2mxl8vdcdnzy0bwis4jk28pd7nc8qgr4vhyw5pd48dynvh";
  };

  patches = [ ./add-amflags.patch ];

  preBuild = ''
    ./autogen.sh --prefix=$out
  '';

  NIX_CFLAGS_COMPILE = "-Wno-error=deprecated-declarations";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ which gnome3.gnome-common glib intltool libtool cairo gtk3 xorg.xwininfo xorg.libXdamage ]
  ++ (with gst_all_1; [ gstreamer gst-plugins-base gst-plugins-bad gst-plugins-good gst-plugins-ugly gst-libav wrapGAppsHook ]);

  meta = with lib; {
    description = "Tool to record a running X desktop to an animation suitable for presentation in a web browser";
    homepage = "https://github.com/GNOME/byzanz";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = [ ];
  };
}
