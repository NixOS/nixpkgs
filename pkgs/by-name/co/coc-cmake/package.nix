{
  lib,
  stdenv,
  nodejs,
  pnpm_8,
  fetchPnpmDeps,
  pnpmConfigHook,
  fetchFromGitHub,
  npmHooks,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "coc-cmake";
  version = "0-unstable-2024-10-21";

  src = fetchFromGitHub {
    owner = "voldikss";
    repo = "coc-extensions";
    rev = "69c81e04fd3350bb75b09232d8ccf26d20075111";
    hash = "sha256-VZRHpy0OTmoQyOEa0vIJl/VkV52r0HEtTzY1fjr6yQ0=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    pnpm = pnpm_8;
    fetcherVersion = 3;
    hash = "sha256-h/ND/665MpcPaDIR1Bb5iPrHmoNysr9vuFk1I0fFP34=";
  };

  pnpmWorkspaces = [ "coc-cmake" ];

  nativeBuildInputs = [
    nodejs
    pnpmConfigHook
    pnpm_8
  ];

  buildPhase = ''
    runHook preBuild

    pnpm run build coc-cmake

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/lib/node_modules
    mv packages/coc-cmake $out/lib/node_modules/coc-cmake
    mv node_modules/.pnpm/ $out/lib/node_modules/.pnpm
    runHook postInstall
  '';

  meta = {
    license = lib.licenses.mit;
  };
})
