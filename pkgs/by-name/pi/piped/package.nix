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
  version = "0-unstable-2026-10-17";

  src = fetchFromGitHub {
    owner = "TeamPiped";
    repo = "piped";
    rev = "38dc94b892ecc1614e241b26cbe023c24517ca9d";
    hash = "sha256-AWRMp0Kw0XxsK2NinhU7Kzcd28+QKB6IQS1UjeOHubk=";
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
