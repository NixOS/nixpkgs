{
  lib,
  stdenv,
  fetchFromGitHub,
  nix-update-script,
  meson,
  ninja,
  pkg-config,
  gtk3,
  glib,
  intltool,
  dbus-glib,
  libx11,
  libxscrnsaver,
  libxxf86vm,
  libxext,
  systemd,
  pantheon,
  wrapGAppsHook3,
}:

stdenv.mkDerivation rec {
  pname = "light-locker";
  version = "1.9.0";

  outputs = [
    "out"
    "man"
  ];

  src = fetchFromGitHub {
    owner = "the-cavalry";
    repo = "light-locker";
    rev = "v${version}";
    hash = "sha256-hkxH26KgqHWViUUP/0fJ7zwX4SwSksBwMV3hJ0BjtPw=";
  };

  nativeBuildInputs = [
    intltool
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    dbus-glib
    glib
    gtk3
    libx11
    libxscrnsaver
    libxext
    libxxf86vm
    systemd
  ];

  mesonFlags = [
    "-Dmit-ext=true"
    "-Ddpms-ext=true"
    "-Dxf86gamma-ext=true"
    "-Dsystemd=true"
    "-Dupower=true"
    "-Dlate-locking=true"
    "-Dlock-on-suspend=true"
    "-Dlock-on-lid=true"
    "-Dgsettings=true"
  ];

  postInstall = ''
    ${glib.dev}/bin/glib-compile-schemas $out/share/glib-2.0/schemas
  '';

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    homepage = "https://github.com/the-cavalry/light-locker";
    description = "Simple session-locker for LightDM";
    longDescription = ''
      A simple locker (forked from gnome-screensaver) that aims to
      have simple, sane, secure defaults and be well integrated with
      the desktop while not carrying any desktop-specific
      dependencies.

      It relies on LightDM for locking and unlocking your session via
      ConsoleKit/UPower or logind/systemd.
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ obadz ];
    teams = [ lib.teams.pantheon ];
    platforms = lib.platforms.linux;
  };
}
