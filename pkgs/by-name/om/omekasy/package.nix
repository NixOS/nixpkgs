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

  useFetchCargoVendor = true;
  cargoHash = "sha256-Bhxj77E/HXvAmTO3S7DW6ZGOk9lqpZMwGv7DN58skP0=";

  buildNoDefaultFeatures = stdenv.targetPlatform.isWasi;

  meta = {
    description = "Command line application that converts alphanumeric characters to various styles defined in Unicode";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.jcaesar ];
    homepage = "https://github.com/ikanago/omekasy";
    mainProgram = "omekasy";
  };
}
