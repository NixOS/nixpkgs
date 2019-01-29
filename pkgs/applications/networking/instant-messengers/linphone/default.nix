{ stdenv, intltool, pkgconfig, readline, openldap, cyrus_sasl, libupnp
, zlib, libxml2, gtk2, libnotify, speex, ffmpeg, libX11, libsoup, udev
, ortp, mediastreamer, sqlite, belle-sip, libosip, libexosip, bzrtp
, mediastreamer-openh264, bctoolbox, makeWrapper, fetchFromGitHub, cmake
, libmatroska, bcunit, doxygen, gdk_pixbuf, glib, cairo, pango, polarssl
, python, graphviz, belcard
, withGui ? true
}:

stdenv.mkDerivation rec {
  baseName = "linphone";
  version = "3.12.0";
  name = "${baseName}-${version}";

  src = fetchFromGitHub {
    owner = "BelledonneCommunications";
    repo = "${baseName}";
    rev = "${version}";
    sha256 = "0az2ywrpx11sqfb4s4r2v726avcjf4k15bvrqj7xvhz7hdndmh0j";
  };

  cmakeFlags = stdenv.lib.optional withGui [ "-DENABLE_GTK_UI=ON" ];

  postPatch = ''
    touch coreapi/liblinphone_gitversion.h
  '';

  buildInputs = [
    readline openldap cyrus_sasl libupnp zlib libxml2 gtk2 libnotify speex ffmpeg libX11
    polarssl libsoup udev ortp mediastreamer sqlite belle-sip libosip libexosip
    bctoolbox libmatroska bcunit gdk_pixbuf glib cairo pango bzrtp belcard
  ];

  nativeBuildInputs = [
    intltool pkgconfig makeWrapper cmake doxygen graphviz
    (python.withPackages (ps: [ ps.pystache ps.six ]))
  ];

  NIX_CFLAGS_COMPILE = " -Wno-error -I${glib.dev}/include/glib-2.0
    -I${glib.out}/lib/glib-2.0/include -I${gtk2.dev}/include/gtk-2.0/
    -I${cairo.dev}/include/cairo -I${pango.dev}/include/pango-1.0
    -I${gtk2}/lib/gtk-2.0/include
    -DLIBLINPHONE_GIT_VERSION=\"v${version}\"
    ";

  postInstall = ''
    for i in $(cd $out/bin && ls); do
      wrapProgram $out/bin/$i --set MEDIASTREAMER_PLUGINS_DIR ${mediastreamer-openh264}/lib/mediastreamer/plugins
    done
  '';

  meta = with stdenv.lib; {
    homepage = http://www.linphone.org/;
    description = "Open Source video SIP softphone";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
