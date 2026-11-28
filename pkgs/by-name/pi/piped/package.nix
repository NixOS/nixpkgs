{
  lib,
  buildNpmPackage,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  fetchFromGitHub,
  nix-update-script,
}:
let
  pnpm = pnpm_10;
in
buildNpmPackage rec {
  pname = "piped";
  version = "0-unstable-2026-11-23";

  src = fetchFromGitHub {
    owner = "TeamPiped";
    repo = "piped";
    rev = "836b2a112a1826953dd8030ccfb7cb8a457a737a";
    hash = "sha256-EWb0r9gJ8ewlawm9Cx65S/Oan08SCwf3EuU45ceCrmc=";
  };

  nativeBuildInputs = [ pnpm ];
  npmConfigHook = pnpmConfigHook;

  installPhase = ''
    runHook preInstall
    cp dist $out -r
    runHook postInstall
  '';

  npmDeps = pnpmDeps;
  pnpmDeps = fetchPnpmDeps {
    inherit
      pname
      version
      src
      pnpm
      ;
    fetcherVersion = 4;
    hash = "sha256-oEovHI8CcuOo6WaohMj3mEN/AbPOPUBGFE5q9NvCV0s=";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    homepage = "https://github.com/TeamPiped/Piped";
    description = "Efficient and privacy-friendly YouTube frontend";
    maintainers = [ ];
    license = lib.licenses.agpl3Plus;
  };

}
