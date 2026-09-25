{
  monolithic ? true, # build monolithic Quassel
  enableDaemon ? false, # build Quassel daemon
  client ? false, # build Quassel client
  tag ? "-kf6", # tag added to the package name
  static ? false, # link statically

  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  makeWrapper,
  dconf,
  boost,
  zlib,
  openldap,

  qt6,
  qt6Packages,
  kdePackages,

  withKDE ? true, # enable KDE integration
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
stdenv.mkDerivation {
  pname = "quassel${tag}";
  version = "0.14.0-unstable-2026-08-09";

  src = fetchFromGitHub {
    owner = "quassel";
    repo = "quassel";
    rev = "15e764d9bb836f13283be80c8135936f6a1cac72"; # https://github.com/quassel/quassel/pull/631
    sha256 = "sha256-Ogf2zv6SKnn+UwQ2meDYTk7axYkWTdnKqUhbJVMUBbo=";
    # i18n repo
    fetchSubmodules = true;
  };

  # Prevent ``undefined reference to `qt_version_tag''' in SSL check
  env.NIX_CFLAGS_COMPILE = "-DQT_NO_VERSION_TAGGING=1";

  nativeBuildInputs = [
    cmake
    makeWrapper
  ]
  ++ lib.optionals buildClient [
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qt5compat
    boost
    zlib
  ]
  ++ lib.optionals buildCore [
    qt6Packages.qca
    openldap
  ]
  ++ lib.optionals buildClient [
    qt6.qtwebengine
    qt6.qtmultimedia
  ]
  ++ lib.optionals (buildClient && withKDE) [
    kdePackages.extra-cmake-modules
    kdePackages.knotifications
    kdePackages.knotifyconfig
    kdePackages.sonnet
    kdePackages.ktextwidgets
    kdePackages.kwidgetsaddons
    kdePackages.kxmlgui
  ];

  cmakeFlags = [
    "-DEMBED_DATA=OFF"
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
      wrapProgram "$out/bin/quasselcore" --suffix PATH : "${qt6.qtbase}/bin"
    ''
    + lib.optionalString buildClient ''
      wrapQtApp "$out/bin/quassel${lib.optionalString client "client"}" \
        --prefix GIO_EXTRA_MODULES : "${dconf}/lib/gio/modules"
    '';

  meta = {
    homepage = "https://quassel-irc.org/";
    description = "Qt/KDE distributed IRC client supporting a remote daemon";
    longDescription = ''
      Quassel IRC is a cross-platform, distributed IRC client,
      meaning that one (or multiple) client(s) can attach to
      and detach from a central core -- much like the popular
      combination of screen and a text-based IRC client such
      as WeeChat, but graphical (based on Qt/KF).
    '';
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ ninelore ];
    mainProgram =
      if monolithic then
        "quassel"
      else if buildClient then
        "quasselclient"
      else
        "quasselcore";
    inherit (qt6.qtbase.meta) platforms;
  };
}
