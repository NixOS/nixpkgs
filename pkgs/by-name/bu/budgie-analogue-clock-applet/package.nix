{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vala,
  budgie-desktop,
  gtk3,
  libpeas,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-analogue-clock-applet";
  version = "2.0";

  src = fetchFromGitHub {
    owner = "samlane-ma";
    repo = "analogue-clock-applet";
    rev = "v${finalAttrs.version}";
    hash = "sha256-yId5bbdmELinBmZ5eISa5hQSYkeZCkix2FJ287GdcCs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    budgie-desktop
    gtk3
    libpeas
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Analogue Clock Applet for the Budgie desktop";
    homepage = "https://github.com/samlane-ma/analogue-clock-applet";
    changelog = "https://github.com/samlane-ma/analogue-clock-applet/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    maintainers = lib.teams.budgie.members;
    platforms = lib.platforms.linux;
  };
})
