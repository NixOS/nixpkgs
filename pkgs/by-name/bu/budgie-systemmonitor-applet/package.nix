{
  lib,
  stdenv,
  budgie-desktop,
  fetchFromGitHub,
  glib,
  gtk3,
  libgee,
  libgtop,
  libpeas,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  vala,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-systemmonitor-applet";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "prateekmedia";
    repo = "budgie-systemmonitor-applet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OWGy2LokpMOW4ZR3K+Bym7i88xQAJqWO43Pu7SjxRSw=";
  };

  # Remove if/when https://github.com/prateekmedia/budgie-systemmonitor-applet/pull/3 is merged
  patches = [ ./install-schemas-to-datadir.patch ];

  strictDeps = true;

  nativeBuildInputs = [
    glib # For `glib-compile-schemas`
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    budgie-desktop
    glib
    gtk3
    libgee
    libgtop
    libpeas
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Budgie applet to show cpu frequency, ram, swap, network and uptime";
    homepage = "https://github.com/prateekmedia/budgie-systemmonitor-applet";
    changelog = "https://github.com/prateekmedia/budgie-systemmonitor-applet/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = lib.teams.budgie.members;
    platforms = lib.platforms.linux;
  };
})
