{
  monolithic ? true, # build monolithic Quassel
  enableDaemon ? false, # build Quassel daemon
  client ? false, # build Quassel client
  tag ? "-kf5", # tag added to the package name
  static ? false, # link statically

  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeWrapper,
  dconf,
  mkDerivation,
  qtbase,
  boost,
  zlib,
  qtscript,
  phonon,
  libdbusmenu,
  qca-qt5,
  openldap,

  withKDE ? true, # enable KDE integration
  extra-cmake-modules,
  kconfigwidgets,
  kcoreaddons,
  knotifications,
  knotifyconfig,
  ktextwidgets,
  kwidgetsaddons,
  kxmlgui,
}:

let
  buildClient = monolithic || client;
  buildCore = monolithic || enableDaemon;
in

assert monolithic -> !client && !enableDaemon;
assert client || enableDaemon -> !monolithic;
assert !buildClient -> !withKDE; # KDE is used by the client only

let
  edf = flag: feature: [ ("-D" + feature + (if flag then "=ON" else "=OFF")) ];

in
(if !buildClient then stdenv.mkDerivation else mkDerivation) rec {
  pname = "quassel${tag}";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "quassel";
    repo = "quassel";
    rev = version;
    sha256 = "sha256-eulhNcyCmy9ryietOhT2yVJeJH+MMZRbTUo2XuTy9qU=";
  };

  # Prevent ``undefined reference to `qt_version_tag''' in SSL check
  env.NIX_CFLAGS_COMPILE = "-DQT_NO_VERSION_TAGGING=1";

  nativeBuildInputs = [
    cmake
    makeWrapper
  ];
  buildInputs =
    [
      qtbase
      boost
      zlib
    ]
    ++ lib.optionals buildCore [
      qtscript
      qca-qt5
      openldap
    ]
    ++ lib.optionals buildClient [
      libdbusmenu
      phonon
    ]
    ++ lib.optionals (buildClient && withKDE) [
      extra-cmake-modules
      kconfigwidgets
      kcoreaddons
      knotifications
      knotifyconfig
      ktextwidgets
      kwidgetsaddons
      kxmlgui
    ];

  cmakeFlags =
    [
      "-DEMBED_DATA=OFF"
      "-DUSE_QT5=ON"
    ]
    ++ edf static "STATIC"
    ++ edf monolithic "WANT_MONO"
    ++ edf enableDaemon "WANT_CORE"
    ++ edf enableDaemon "WITH_LDAP"
    ++ edf client "WANT_QTCLIENT"
    ++ edf withKDE "WITH_KDE";

  dontWrapQtApps = true;

  postFixup =
    lib.optionalString enableDaemon ''
      wrapProgram "$out/bin/quasselcore" --suffix PATH : "${qtbase.bin}/bin"
    ''
    + lib.optionalString buildClient ''
      wrapQtApp "$out/bin/quassel${lib.optionalString client "client"}" \
        --prefix GIO_EXTRA_MODULES : "${dconf}/lib/gio/modules"
    '';

  meta = with lib; {
    homepage = "https://quassel-irc.org/";
    description = "Qt/KDE distributed IRC client supporting a remote daemon";
    longDescription = ''
      Quassel IRC is a cross-platform, distributed IRC client,
      meaning that one (or multiple) client(s) can attach to
      and detach from a central core -- much like the popular
      combination of screen and a text-based IRC client such
      as WeeChat, but graphical (based on Qt4/KDE4 or Qt5/KF5).
    '';
    license = licenses.gpl3;
    maintainers = with maintainers; [ ttuegel ];
    inherit (qtbase.meta) platforms;
  };
}
