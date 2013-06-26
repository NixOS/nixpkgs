{ stdenv, fetchurl, libyaml, alsaLib, openssl, libuuid, pkgconfig, pulseaudio, libsamplerate,
commoncpp2, ccrtp, libzrtpcpp, dbus, dbus_cplusplus, expat, pcre, gsm, speex, ilbc, libopus,
autoconf, automake, libtool, gettext, perl }:

stdenv.mkDerivation rec {
  name = "sflphone-1.2.3";

  src = fetchurl {
    url = "https://projects.savoirfairelinux.com/attachments/download/6423/${name}.tar.gz";
    sha256 = "0aiwlky7mp5l51a7kkhkmaz7ivapypar291kdxzdxl1s3qy0x6fd";
  };

  patches = [ ./libzrtpcpp-cflags.patch ];

  preConfigure = ''
    cd daemon

    # Post patch, required
    autoreconf -vfi

    cd libs
    bash ./compile_pjsip.sh
    cd ..
  '';

  configureFlags = "--with-expat --with-expat-inc=${expat}/include " +
    "--with-expat-lib=-lexpat --with-opus ";

  buildInputs = [ libyaml alsaLib openssl libuuid pkgconfig pulseaudio libsamplerate 
    commoncpp2 ccrtp libzrtpcpp dbus dbus_cplusplus expat pcre gsm speex ilbc libopus
    autoconf automake libtool gettext perl ];
}
