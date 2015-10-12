{ monolithic ? true # build monolithic Quassel
, daemon ? false # build Quassel daemon
, client ? false # build Quassel client
, previews ? false # enable webpage previews on hovering over URLs
, tag ? "" # tag added to the package name

, stdenv, fetchurl, cmake, makeWrapper, dconf
, qtbase, qtscript, qtwebkit
, phonon, libdbusmenu, qca-qt5

, withKDE ? stdenv.isLinux # enable KDE integration
, extra-cmake-modules
, kconfigwidgets
, kcoreaddons
, knotifications
, knotifyconfig
, ktextwidgets
, kwidgetsaddons
, kxmlgui
}:

let
    buildClient = monolithic || client;
    buildCore = monolithic || daemon;
in

assert stdenv.isLinux;

assert monolithic -> !client && !daemon;
assert client || daemon -> !monolithic;
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

  patches = [
    # fix build with Qt 5.5
    (fetchurl {
      url = "https://github.com/quassel/quassel/commit/078477395aaec1edee90922037ebc8a36b072d90.patch";
      sha256 = "1njwnay7pjjw0g7m0x5cwvck8xcznc7jbdfyhbrd121nc7jgpbc5";
    })
  ];

  enableParallelBuilding = true;

  buildInputs =
       [ cmake makeWrapper qtbase ]
    ++ lib.optionals buildCore [qtscript qca-qt5]
    ++ lib.optionals buildClient [libdbusmenu phonon]
    ++ lib.optionals (buildClient && previews) [qtwebkit]
    ++ lib.optionals (buildClient && withKDE) [
      extra-cmake-modules kconfigwidgets kcoreaddons
      knotifications knotifyconfig ktextwidgets kwidgetsaddons
      kxmlgui
    ];

  cmakeFlags = [
    "-DEMBED_DATA=OFF"
    "-DSTATIC=OFF"
    "-DUSE_QT5=ON"
  ]
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
    inherit (qtbase.meta) platforms;
  };
}
