{ monolithic ? true # build monolithic Quassel
, daemon ? false # build Quassel daemon
, client ? false # build Quassel client
, withKDE ? stdenv.isLinux # enable KDE integration
, ssl ? true # enable SSL support
, previews ? false # enable webpage previews on hovering over URLs
, tag ? "" # tag added to the package name
, stdenv, fetchurl, cmake, makeWrapper, qt4, kdelibs, automoc4, phonon, dconf }:

let
  edf = flag: feature: [("-D" + feature + (if flag then "=ON" else "=OFF"))];

in with stdenv; mkDerivation rec {

  version = "0.10.0";
  name = "quassel${tag}-${version}";

  src = fetchurl {
    url = "http://quassel-irc.org/pub/quassel-${version}.tar.bz2";
    sha256 = "08vwxkwnzlgnxn0wi6ga9fk8qgc6nklb236hsfnr5ad37bi8q8k8";
  };

  enableParallelBuilding = true;

  buildInputs = [ cmake makeWrapper qt4 ]
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

  preFixup = ''
    wrapProgram "$out/bin/quasselclient" \
      --prefix GIO_EXTRA_MODULES : "${dconf}/lib/gio/modules"
  '';

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

