{ stdenv, fetchurl, libyaml, alsaLib, openssl, libuuid, pkgconfig, pulseaudio, libsamplerate
, commoncpp2, ccrtp, libzrtpcpp, dbus, dbus_cplusplus, expat, pcre, gsm, speex, ilbc, libopus
, autoconf, automake, libtool, gettext, perl
, cmake, qt4
, gtk, glib, dbus_glib, libnotify, intltool, makeWrapper }:

let
  name = "sflphone-1.2.3";

  src = fetchurl {
    url = "https://projects.savoirfairelinux.com/attachments/download/6423/${name}.tar.gz";
    sha256 = "0aiwlky7mp5l51a7kkhkmaz7ivapypar291kdxzdxl1s3qy0x6fd";
  };

  meta = {
    homepage = http://sflphone.org/;
    license = "GPLv3+";
    description = "Free software enterprise-class softphone for GNU/Linux";
    platforms = with stdenv.lib.platforms; linux;
    maintainers = with stdenv.lib.maintainers; [viric];
  };

in
rec {
  daemon = stdenv.mkDerivation {
    name = name + "-daemon";

    inherit src;

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
  };

  # This fails still.
  # I don't know the best way to make this a KDE program (with switchable kde
  # libs, like digikam for example)
  /*
  kde = stdenv.mkDerivation {
    name = name + "-kde";

    inherit src;

    preConfigure = ''
      cd kde
    '';

    buildInputs = [ daemon cmake qt4 pkgconfig ];
  };
  */

  gnome = stdenv.mkDerivation {
    name = name + "-gnome";

    inherit src;

    preConfigure = ''
      cd gnome
    '';

    # gtk3 programs have the runtime dependency on XDG_DATA_DIRS
    postInstall = ''
      wrapProgram $out/bin/sflphone* --prefix XDG_DATA_DIRS ":" ${gtk}/share
    '';

    buildInputs = [ daemon pkgconfig gtk glib dbus_glib libnotify intltool makeWrapper ];
  };
}
