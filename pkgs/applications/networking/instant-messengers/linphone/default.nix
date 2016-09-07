{ stdenv, fetchurl, intltool, pkgconfig, readline, openldap, cyrus_sasl, libupnp
, zlib, libxml2, gtk2, libnotify, speex, ffmpeg, libX11, libsoup, udev
, ortp, mediastreamer, sqlite, belle-sip, libosip, libexosip
, mediastreamer-openh264, bctoolbox, makeWrapper, fetchFromGitHub, cmake
, libmatroska, bcunit, doxygen, gdk_pixbuf, glib, cairo, pango, polarssl
}:

stdenv.mkDerivation rec {
  baseName = "linphone";
  version = "3.10.2";
  name = "${baseName}-${version}";

  src = fetchFromGitHub {
    owner = "BelledonneCommunications";
    repo = "${baseName}";
    rev = "${version}";
    sha256 = "053gad4amdbq5za8f2n9j5q59nkky0w098zbsa3dvpcqvv7ar16p";
  };

  buildInputs = [
    readline openldap cyrus_sasl libupnp zlib libxml2 gtk2 libnotify speex ffmpeg libX11
    polarssl libsoup udev ortp mediastreamer sqlite belle-sip libosip libexosip
    bctoolbox libmatroska bcunit gdk_pixbuf glib cairo pango
  ];

  nativeBuildInputs = [ intltool pkgconfig makeWrapper cmake doxygen ];

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
