{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:
let
  version = "11.0.1";
in
buildNpmPackage {
  pname = "postcss-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "postcss";
    repo = "postcss-cli";
    tag = version;
    hash = "sha256-47OklUatlbunv3FcS816nZhWlbGjeZb7Vg6891fp2Gs=";
  };

  patches = [ ./add-package-lock-json.patch ];

  npmDepsHash = "sha256-0Z9u/F6K/hq6bbpoaRG5dSPb4BUABu66LZP2D7pWqEo=";

  dontNpmBuild = true;
  dontNpmPrune = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "CLI for postcss";
    homepage = "https://github.com/postcss/postcss-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ DoctorDalek1963 ];
  };
}
