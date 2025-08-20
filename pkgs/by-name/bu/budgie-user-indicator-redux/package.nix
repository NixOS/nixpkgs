{
  lib,
  stdenv,
  fetchFromGitHub,
  accountsservice,
  budgie-desktop,
  gtk3,
  intltool,
  libgee,
  libpeas,
  meson,
  ninja,
  nix-update-script,
  pkg-config,
  sassc,
  vala,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-user-indicator-redux";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "EbonJaeger";
    repo = "budgie-user-indicator-redux";
    rev = "v${finalAttrs.version}";
    hash = "sha256-X9b4H4PnrYGb/T7Sg9iXQeNDLoO1l0VCdbOCGUAgwC4=";
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
    libpeas
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
    maintainers = lib.teams.budgie.members;
  };
})
