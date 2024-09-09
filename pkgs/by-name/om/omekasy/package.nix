{
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  lib,
}:
rustPlatform.buildRustPackage rec {
  pname = "omekasy";
  version = "1.2.3";

  src = fetchFromGitHub {
    owner = "ikanago";
    repo = "omekasy";
    rev = "v${version}";
    hash = "sha256-oPhO+gRWrwgABc+gGXnIC519F5XVvewUHo2y54RoE4U=";
  };

  cargoHash = "sha256-6GjNn7FAcAihqNhPD18sUFe40ZQwXmFEQmoZNZL2trQ=";

  buildNoDefaultFeatures = stdenv.targetPlatform.isWasi;

  meta = {
    description = "Command line application that converts alphanumeric characters to various styles defined in Unicode";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jcaesar ];
    homepage = "https://github.com/ikanago/omekasy";
    mainProgram = "omekasy";
  };
}
