{
  lib,
  stdenv,
  nodejs,
  pnpm_8,
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

  pnpmDeps = pnpm_8.fetchDeps {
    inherit (finalAttrs)
      pname
      version
      src
      pnpmWorkspaces
      ;
    fetcherVersion = 2;
    hash = "sha256-wQ9dcqY7BVXc7wpsHlYNpc7utL1+MkdTCu77Wh8+QWc=";
  };

  pnpmWorkspaces = [ "coc-cmake" ];

  nativeBuildInputs = [
    nodejs
    pnpm_8.configHook
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

})
