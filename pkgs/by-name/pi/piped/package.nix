{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  fetchPnpmDeps,
  nix-update-script,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "piped";
  version = "0-unstable-2026-09-11";

  src = fetchFromGitHub {
    owner = "TeamPiped";
    repo = "piped";
    rev = "70453d1b5795d4acee90a33a2596a315ef72d961";
    hash = "sha256-dDdTUgxJb3/WXCf4os8Q2KzSljBGPXqKq2zOeyuT7pk=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_10
    pnpmConfigHook
  ];

  buildPhase = ''
    runHook preBuild

    pnpm build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    cp -r dist "$out"

    runHook postInstall
  '';

  strictDeps = true;
  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    pnpm = pnpm_10;
    fetcherVersion = 4;
    hash = "sha256-oEovHI8CcuOo6WaohMj3mEN/AbPOPUBGFE5q9NvCV0s=";
  };

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version=branch" ];
  };

  meta = {
    homepage = "https://github.com/TeamPiped/Piped";
    description = "Efficient and privacy-friendly YouTube frontend";
    maintainers = [ lib.maintainers.SchweGELBin ];
    license = lib.licenses.agpl3Plus;
  };

})
