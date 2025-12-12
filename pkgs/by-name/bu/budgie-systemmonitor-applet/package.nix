{
  lib,
  stdenv,
  budgie-desktop,
  fetchFromGitHub,
  glib,
  gtk3,
  libgee,
  libgtop,
  libpeas2,
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
    libpeas2
  ];

  postPatch = ''
    # https://github.com/BuddiesOfBudgie/budgie-desktop/issues/749
    # https://github.com/prateekmedia/budgie-systemmonitor-applet/issues/4
    substituteInPlace meson.build \
      --replace-fail "dependency('libpeas-1.0', version: '>= 1.8.0')" "dependency('libpeas-2')" \
      --replace-fail "dependency('budgie-1.0', version: '>= 2')" "dependency('budgie-2.0')"
  '';

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
