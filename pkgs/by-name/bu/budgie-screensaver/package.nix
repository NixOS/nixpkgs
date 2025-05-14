{
  lib,
  stdenv,
  fetchFromGitHub,
  dbus-glib,
  glib,
  gnome-desktop,
  gtk3,
  intltool,
  libgnomekbd,
  libX11,
  linux-pam,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  systemd,
  testers,
  wrapGAppsHook3,
  xorg,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-screensaver";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = "budgie-screensaver";
    rev = "v${finalAttrs.version}";
    hash = "sha256-N8x9hdbaMDisTbQPJedNO4UMLnCn+Q2hhm4udJZgQlc=";
  };

  outputs = [
    "out"
    "man"
  ];

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
    gnome-desktop
    gtk3
    libgnomekbd
    libX11
    linux-pam
    systemd
    xorg.libXxf86vm
  ];

  # Fix GCC 14 build.
  # https://hydra.nixos.org/build/282164464/nixlog/3
  env.NIX_CFLAGS_COMPILE = "-D_POSIX_C_SOURCE -Wno-error=implicit-function-declaration";

  passthru = {
    tests.version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "budgie-screensaver-command --version";
    };

    updateScript = nix-update-script { };
  };

  meta = {
    description = "Fork of old GNOME Screensaver for purposes of providing an authentication prompt on wake";
    homepage = "https://github.com/BuddiesOfBudgie/budgie-screensaver";
    changelog = "https://github.com/BuddiesOfBudgie/budgie-screensaver/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl2Only;
    teams = [ lib.teams.budgie ];
    mainProgram = "budgie-screensaver";
    platforms = lib.platforms.linux;
  };
})
