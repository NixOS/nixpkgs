{ stdenv, fetchurl, intltool, pkgconfig, readline, openldap, cyrus_sasl, libupnp
, zlib, libxml2, gtk2, libnotify, speex, ffmpeg, libX11, libsoup, udev
, ortp, mediastreamer, sqlite, belle-sip, libosip, libexosip
, mediastreamer-openh264, makeWrapper
}:

stdenv.mkDerivation rec {
  name = "linphone-${version}";
  major = "3.9";
  version = "${major}.1";

  src = fetchurl {
    url = "mirror://savannah/linphone/${major}.x/sources/${name}.tar.gz";
    sha256 = "1b14gwq36d0sbn1125if9zydll9kliigk19zchbqiy9n2gjymrl4";
  };

  buildInputs = [
    readline openldap cyrus_sasl libupnp zlib libxml2 gtk2 libnotify speex ffmpeg libX11
    libsoup udev ortp mediastreamer sqlite belle-sip libosip libexosip
  ];

  nativeBuildInputs = [ intltool pkgconfig makeWrapper ];

  configureFlags = [
    "--enable-ldap"
    "--with-ffmpeg=${ffmpeg.dev}"
    "--enable-external-ortp"
    "--enable-external-mediastreamer"
  ];

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
