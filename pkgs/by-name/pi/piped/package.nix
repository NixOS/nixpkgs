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
  version = "0-unstable-2026-08-09";

  src = fetchFromGitHub {
    owner = "TeamPiped";
    repo = "piped";
    rev = "5ef4a0d0072753521cb7584075346623b8282402";
    hash = "sha256-8vuanaSjspGkminCO2fTrGhecpoGgTcpEtl7YT2ZDYA=";
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
    hash = "sha256-mBEzm+GzF/V3W/6JPOn81YawAMaSTw8THtOUb3qtmvc=";
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
