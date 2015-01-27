{ monolithic ? true # build monolithic Quassel
, daemon ? false # build Quassel daemon
, client ? false # build Quassel client
, withKDE ? stdenv.isLinux # enable KDE integration
, ssl ? true # enable SSL support
, previews ? false # enable webpage previews on hovering over URLs
, tag ? "" # tag added to the package name
, kdelibs ? null # optional
, useQt5 ? false
, phonon_qt5, libdbusmenu_qt5
, stdenv, fetchurl, cmake, makeWrapper, qt, automoc4, phonon, dconf }:

assert monolithic -> !client && !daemon;
assert client || daemon -> !monolithic;
assert withKDE -> kdelibs != null;

let
  edf = flag: feature: [("-D" + feature + (if flag then "=ON" else "=OFF"))];

in with stdenv; mkDerivation rec {

  version = "0.11.0";
  name = "quassel${tag}-${version}";

  src = fetchurl {
    url = "http://quassel-irc.org/pub/quassel-${version}.tar.bz2";
    sha256 = "01251y5i1fvm6s2g9acxaczk2jdyw1byr45q41q0yh9apjw938cr";
  };

  enableParallelBuilding = true;

  buildInputs = [ cmake makeWrapper qt ]
    ++ lib.optional withKDE kdelibs
    ++ lib.optional withKDE automoc4
    ++ lib.optional withKDE phonon
    ++ lib.optional useQt5 phonon_qt5
    ++ lib.optional useQt5 libdbusmenu_qt5;

  cmakeFlags = [
    "-DEMBED_DATA=OFF"
    "-DSTATIC=OFF" ]
    ++ edf monolithic "WANT_MONO"
    ++ edf daemon "WANT_CORE"
    ++ edf client "WANT_QTCLIENT"
    ++ edf withKDE "WITH_KDE"
    ++ edf previews "WITH_WEBKIT"
    ++ edf useQt5 "USE_QT5";

  preFixup =
    lib.optionalString client ''
        wrapProgram "$out/bin/quasselclient" \
          --prefix GIO_EXTRA_MODULES : "${dconf}/lib/gio/modules"
    '' +
    lib.optionalString monolithic ''
        wrapProgram "$out/bin/quassel" \
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
    license = stdenv.lib.licenses.gpl3;
    maintainers = [ maintainers.phreedom ];
    repositories.git = https://github.com/quassel/quassel.git;
    inherit (qt.meta) platforms;
  };
}
