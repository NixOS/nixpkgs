{
  lib,
  stdenv,
  fetchFromGitHub,
  imagemagick,
  meson,
  ninja,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "budgie-backgrounds";
  version = "4.1";

  src = fetchFromGitHub {
    owner = "BuddiesOfBudgie";
    repo = "budgie-backgrounds";
    rev = "v${finalAttrs.version}";
    hash = "sha256-veUGYYUIHfz8MTaVNWaOkWl2byWEQhTSp9iikSPcHsw=";
  };

  nativeBuildInputs = [
    imagemagick
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
    teams = [ lib.teams.budgie ];
    platforms = lib.platforms.linux;
  };
})
