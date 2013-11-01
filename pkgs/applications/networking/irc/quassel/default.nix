{ monolithic ? true # build monolithic Quassel
, daemon ? false # build Quassel daemon
, client ? false # build Quassel client
, withKDE ? stdenv.isLinux # enable KDE integration
, ssl ? true # enable SSL support
, previews ? false # enable webpage previews on hovering over URLs
, stdenv, fetchurl, cmake, qt4, kdelibs, automoc4, phonon }:

let
  edf = flag: feature: [("-D" + feature + (if flag then "=ON" else "=OFF"))];

in with stdenv; mkDerivation rec {

  name = "quassel-0.9.0";

  src = fetchurl {
    url = "http://quassel-irc.org/pub/${name}.tar.bz2";
    sha256 = "09v0igjkzan3hllk47w39hkav6v1419vpxn2lfd8473kwdmf0grf";
  };

  buildInputs = [ cmake qt4 ]
    ++ lib.optional withKDE kdelibs
    ++ lib.optional withKDE automoc4
    ++ lib.optional withKDE phonon;

  cmakeFlags = [
    "-DWITH_DBUS=OFF"
    "-DWITH_LIBINDICATE=OFF"
    "-DEMBED_DATA=OFF"
    "-DSTATIC=OFF"
    "-DWITH_PHONON=ON" ]
    ++ edf monolithic "WANT_MONO"
    ++ edf daemon "WANT_CORE"
    ++ edf client "WANT_QTCLIENT"
    ++ edf withKDE "WITH_KDE"
    ++ edf ssl "WITH_OPENSSL"
    ++ edf previews "WITH_WEBKIT"  ;

  meta = with stdenv.lib; {
    homepage = http://quassel-irc.org/;
    description = "Qt4/KDE4 distributed IRC client suppporting a remote daemon";
    longDescription = ''
      Quassel IRC is a cross-platform, distributed IRC client,
      meaning that one (or multiple) client(s) can attach to
      and detach from a central core -- much like the popular
      combination of screen and a text-based IRC client such
      as WeeChat, but graphical (based on Qt4/KDE4).
    '';
    license = "GPLv3";
    maintainers = [ maintainers.phreedom ];
    repositories.git = https://github.com/quassel/quassel.git;
    inherit (qt4.meta) platforms;
  };
}

