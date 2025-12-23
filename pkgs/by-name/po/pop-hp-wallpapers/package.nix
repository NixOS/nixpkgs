{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  imagemagick,
  nix-update-script,
}:

stdenvNoCC.mkDerivation {
  pname = "pop-hp-wallpapers";
  version = "0-unstable-2025-10-28";

  src = fetchFromGitHub {
    owner = "pop-os";
    repo = "hp-wallpapers";
    rev = "94f7df30f6bf1c3d71522018852d77c10b920ea3";
    forceFetchGit = true;
    fetchLFS = true;
    hash = "sha256-AthVQ9kQO+CvSH1xxz/U6WzAtpcXK1gvRwKyeo0vMSs=";
  };

  nativeBuildInputs = [ imagemagick ];

  makeFlags = [ "prefix=$(out)" ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Wallpapers for High-Performance System76 products";
    homepage = "https://pop.system76.com/";
    license = with lib.licenses; [ cc-by-sa-40 ];
    maintainers = with lib.maintainers; [ pandapip1 ];
    platforms = lib.platforms.all;
  };
}
