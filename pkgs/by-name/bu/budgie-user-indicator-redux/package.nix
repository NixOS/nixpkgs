{
  lib,
  stdenv,
  fetchFromGitHub,
  accountsservice,
  budgie-desktop,
  gtk3,
  intltool,
  libgee,
  libpeas2,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  sassc,
  vala,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-user-indicator-redux";
  version = "1.1.0";

  src = fetchFromGitHub {
    owner = "EbonJaeger";
    repo = "budgie-user-indicator-redux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZvT114F0g+3zpskyb4Bn6grAXHWtMqRqb9MzfF0WLQ8=";
  };

  nativeBuildInputs = [
    intltool
    meson
    ninja
    pkg-config
    vala
  ];

  buildInputs = [
    accountsservice
    budgie-desktop
    gtk3
    libgee
    libpeas2
    sassc
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Manage your user session from the Budgie panel";
    homepage = "https://github.com/EbonJaeger/budgie-user-indicator-redux";
    changelog = "https://github.com/EbonJaeger/budgie-user-indicator-redux/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.budgie ];
  };
})
