{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm_10,
  pnpmConfigHook,
  fetchPnpmDeps,
  unstableGitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "piped";
  version = "0-unstable-2026-02-20";

  src = fetchFromGitHub {
    owner = "TeamPiped";
    repo = "piped";
    rev = "268ea742c3bf8cfc008ab1ab6206ac807d0776df";
    hash = "sha256-maYRZi/EWY03bR4eUmPNgYvaqFmL4RnASFVYxJAfuPg=";
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

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-mBbcNT+vDtrHtqgVAMVxvh18wuKGtwzkCYSIfzGqYeM=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/TeamPiped/Piped";
    description = "Efficient and privacy-friendly YouTube frontend";
    maintainers = with lib.maintainers; [
      lucasew
      SchweGELBin
    ];
    license = [ lib.licenses.agpl3Plus ];
  };
})
