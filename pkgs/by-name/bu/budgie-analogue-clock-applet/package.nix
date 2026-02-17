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
  gtk-layer-shell,
  libpeas2,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-analogue-clock-applet";
  version = "2.2-unstable-2026-01-13";

  src = fetchFromGitHub {
    owner = "samlane-ma";
    repo = "analogue-clock-applet";
    rev = "22b04faeea8f95eb83ad96ae89529560811d76d9";
    hash = "sha256-8ZFExgE1aJ8XN4+ugSzI34UjdPHbtbhJ+3xetcLZ6sg=";
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
    gtk-layer-shell
    libpeas2
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Analogue Clock Applet for the Budgie desktop";
    homepage = "https://github.com/samlane-ma/analogue-clock-applet";
    changelog = "https://github.com/samlane-ma/analogue-clock-applet/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.budgie ];
    platforms = lib.platforms.linux;
  };
})
