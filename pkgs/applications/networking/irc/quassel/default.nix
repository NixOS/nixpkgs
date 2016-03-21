{ monolithic ? true # build monolithic Quassel
, daemon ? false # build Quassel daemon
, client ? false # build Quassel client
, previews ? false # enable webpage previews on hovering over URLs
, tag ? "" # tag added to the package name
, withKDE ? stdenv.isLinux # enable KDE integration
, kdelibs ? null
, static ? false # link statically

, stdenv, fetchurl, cmake, makeWrapper, qt, automoc4, phonon, dconf, qca2 }:

let buildClient = monolithic || client;
    buildCore = monolithic || daemon;
in

assert stdenv.isLinux;

assert monolithic -> !client && !daemon;
assert client || daemon -> !monolithic;
assert withKDE -> kdelibs != null;
assert !buildClient -> !withKDE; # KDE is used by the client only

let
  edf = flag: feature: [("-D" + feature + (if flag then "=ON" else "=OFF"))];

in with stdenv; mkDerivation rec {

  version = "0.12.3";
  name = "quassel${tag}-${version}";

  src = fetchurl {
    url = "http://quassel-irc.org/pub/quassel-${version}.tar.bz2";
    sha256 = "15vqjiw38mifvnc95bhvy0zl23xxldkwg2byx9xqbyw8rfgggmkb";
  };

  enableParallelBuilding = true;

  buildInputs =
       [ cmake makeWrapper qt ]
    ++ lib.optionals buildCore [qca2]
    ++ lib.optionals withKDE [automoc4 kdelibs phonon];

  NIX_CFLAGS_COMPILE = "-fPIC";

  cmakeFlags = [
    "-DEMBED_DATA=OFF" ]
    ++ edf static "STATIC"
    ++ edf monolithic "WANT_MONO"
    ++ edf daemon "WANT_CORE"
    ++ edf client "WANT_QTCLIENT"
    ++ edf withKDE "WITH_KDE"
    ++ edf previews "WITH_WEBKIT";

  preFixup =
    lib.optionalString buildClient ''
        wrapProgram "$out/bin/quassel${lib.optionalString client "client"}" \
          --prefix GIO_EXTRA_MODULES : "${dconf}/lib/gio/modules"
    '';

  meta = with stdenv.lib; {
    homepage = http://quassel-irc.org/;
    description = "Qt/KDE distributed IRC client suppporting a remote daemon";
    longDescription = ''
      Quassel IRC is a cross-platform, distributed IRC client,
      meaning that one (or multiple) client(s) can attach to
      and detach from a central core -- much like the popular
      combination of screen and a text-based IRC client such
      as WeeChat, but graphical (based on Qt4/KDE4 or Qt5/KF5).
    '';
    license = stdenv.lib.licenses.gpl3;
    maintainers = with maintainers; [ phreedom ttuegel ];
    repositories.git = https://github.com/quassel/quassel.git;
    inherit (qt.meta) platforms;
  };
}
