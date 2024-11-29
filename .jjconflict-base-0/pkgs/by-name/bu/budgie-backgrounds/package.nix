{
  lib,
  stdenv,
  fetchFromGitHub,
  imagemagick,
  jhead,
  meson,
  ninja,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-backgrounds";
  version = "3.0";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = "budgie-backgrounds";
    rev = "v${finalAttrs.version}";
    hash = "sha256-2E6+WDLIAwqiiPMJw+tLDCT3CnpboH4X0cB87zw/hBQ=";
  };

  nativeBuildInputs = [
    imagemagick
    jhead
    meson
    ninja
  ];

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Default background set for the Budgie Desktop";
    homepage = "https://github.com/BuddiesOfBudgie/budgie-backgrounds";
    changelog = "https://github.com/BuddiesOfBudgie/budgie-backgrounds/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.cc0;
    maintainers = lib.teams.budgie.members;
    platforms = lib.platforms.linux;
  };
})
