{ monolithic ? true # build monolithic Quassel
, daemon ? false # build Quassel daemon
, client ? false # build Quassel client
, previews ? false # enable webpage previews on hovering over URLs
, tag ? "" # tag added to the package name
, useQt5 ? false, phonon_qt5, libdbusmenu_qt5, qca-qt5
, withKDE ? stdenv.isLinux # enable KDE integration
, kf5 ? null, kdelibs ? null

, stdenv, fetchurl, cmake, makeWrapper, qt, automoc4, phonon, dconf, qca2 }:

let useKF5 = useQt5 && withKDE;
    useKDE4 = withKDE && !useQt5;
    buildClient = monolithic || client;
    buildCore = monolithic || daemon;
in

assert stdenv.isLinux;

assert monolithic -> !client && !daemon;
assert client || daemon -> !monolithic;
assert useKDE4 -> kdelibs != null;
assert useKF5 -> kf5 != null;
assert !buildClient -> !withKDE; # KDE is used by the client only

let
  edf = flag: feature: [("-D" + feature + (if flag then "=ON" else "=OFF"))];

in with stdenv; mkDerivation rec {

  version = "0.12.2";
  name = "quassel${tag}-${version}";

  src = fetchurl {
    url = "http://quassel-irc.org/pub/quassel-${version}.tar.bz2";
    sha256 = "15vqjiw38mifvnc95bhvy0zl23xxldkwg2byx9xqbyw8rfgggmkb";
  };

  enableParallelBuilding = true;

  buildInputs =
       [ cmake makeWrapper ]
    ++ [(if useQt5 then qt.base else qt)]
    ++ lib.optionals buildCore (if useQt5 then [qt.script qca-qt5] else [qca2])
    ++ lib.optionals buildClient
       (   lib.optionals (previews && useQt5) [qt.webkit qt.webkitwidgets]
        ++ lib.optionals useQt5 [libdbusmenu_qt5 phonon_qt5]
        ++ lib.optionals useKDE4 [automoc4 kdelibs phonon]
        ++ lib.optionals useKF5
           (with kf5; [
             extra-cmake-modules kconfigwidgets kcoreaddons
             knotifications knotifyconfig ktextwidgets kwidgetsaddons
             kxmlgui
           ])
       );

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
    inherit ((if useQt5 then qt.base else qt).meta) platforms;
  };
}
