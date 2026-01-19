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
  version = "2.2";

  src = fetchFromGitHub {
    owner = "samlane-ma";
    repo = "analogue-clock-applet";
    rev = "v${finalAttrs.version}";
    hash = "sha256-8kqDEzcUqg/TvwpazYQt1oQDVC00fOxFLVsKYMDuV9I=";
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

  postPatch = ''
    # https://github.com/samlane-ma/analogue-clock-applet/issues/7
    substituteInPlace budgie-analogue-clock-widget/src/meson.build \
      --replace-fail "dependency('budgie-raven-plugin-1.0')" "dependency('budgie-raven-plugin-2.0')"
  '';

  mesonFlags = [
    # The meson option actually enables libpeas2 support
    # https://github.com/BuddiesOfBudgie/budgie-desktop/issues/749
    "-Dfor-wayland=true"
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
