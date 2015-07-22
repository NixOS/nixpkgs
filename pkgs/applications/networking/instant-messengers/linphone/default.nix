{ stdenv, fetchurl, intltool, pkgconfig, readline, openldap, cyrus_sasl, libupnp
, zlib, libxml2, gtk2, libnotify, speex, ffmpeg, libX11, polarssl, libsoup, udev
, ortp, mediastreamer, sqlite, belle-sip, libosip, libexosip
}:

stdenv.mkDerivation rec {
  name = "linphone-3.8.1";

  src = fetchurl {
    url = "mirror://savannah/linphone/3.8.x/sources/${name}.tar.gz";
    sha256 = "19xwar8z5hyp1bap1s437ipv90gspmjwcq5zznds55d7r6gbqicd";
  };

  buildInputs = [
    readline openldap cyrus_sasl libupnp zlib libxml2 gtk2 libnotify speex ffmpeg libX11
    polarssl libsoup udev ortp mediastreamer sqlite belle-sip libosip libexosip
  ];

  nativeBuildInputs = [ intltool pkgconfig ];

  configureFlags = [
    "--enable-ldap"
    "--with-ffmpeg=${ffmpeg}"
    "--with-polarssl=${polarssl}"
    "--enable-lime"
    "--enable-external-ortp"
    "--enable-external-mediastreamer"
  ];

  meta = with stdenv.lib; {
    homepage = http://www.linphone.org/;
    description = "Open Source video SIP softphone";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };
}
