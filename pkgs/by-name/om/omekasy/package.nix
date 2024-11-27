{
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  lib,
}:
rustPlatform.buildRustPackage rec {
  pname = "omekasy";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "ikanago";
    repo = "omekasy";
    rev = "v${version}";
    hash = "sha256-wI+xN6pyNoP4xknjHHDydHq275Gb1nyp7YtqmABlTBA=";
  };

  cargoHash = "sha256-6CU2ff4o7Y3CmZSf/xs2SSGco2mu4oRLJYIciCld8zo=";

  buildNoDefaultFeatures = stdenv.targetPlatform.isWasi;

  meta = {
    description = "Command line application that converts alphanumeric characters to various styles defined in Unicode";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jcaesar ];
    homepage = "https://github.com/ikanago/omekasy";
    mainProgram = "omekasy";
  };
}
