{
  lib,
  buildNpmPackage,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  fetchFromGitHub,
  unstableGitUpdater,
}:
let
  pnpm = pnpm_9;
in
buildNpmPackage rec {
  pname = "piped";
  version = "0-unstable-2026-02-20";

  src = fetchFromGitHub {
    owner = "TeamPiped";
    repo = "piped";
    rev = "268ea742c3bf8cfc008ab1ab6206ac807d0776df";
    hash = "sha256-maYRZi/EWY03bR4eUmPNgYvaqFmL4RnASFVYxJAfuPg=";
  };

  nativeBuildInputs = [ pnpm_9 ];
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
      ;
    pnpm = pnpm_9;
    fetcherVersion = 3;
    hash = "sha256-SZ4f891OKIuip6Tr8epDEUnjZDMyUHm67hlLOA+kuBs=";
  };

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/TeamPiped/Piped";
    description = "Efficient and privacy-friendly YouTube frontend";
    maintainers = [ lib.maintainers.lucasew ];
    license = [ lib.licenses.agpl3Plus ];
  };

}
