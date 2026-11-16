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
  version = "0-unstable-2026-11-08";

  src = fetchFromGitHub {
    owner = "TeamPiped";
    repo = "piped";
    rev = "4f79bb74f023c46d55bc504ee8399a55282965c7";
    hash = "sha256-QNpkYAzez8VJilvrDE5upS+Oc4tV84WgpMvlO5hHAq4=";
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
