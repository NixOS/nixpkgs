{
  fetchFromGitHub,
  lib,
  rustPlatform,
}: let
  src = fetchFromGitHub {
    owner = "NewDawn0";
    repo = "gen";
    rev = "1b9e403c92de1b80c1e5eae31f09b93609ad3241";
    sha256 = "sha256-DNMsuN3NVWiGJL+b2Qa0lNCp3q0xm/6yFxNUHNbURmE=";
  };
in
  rustPlatform.buildRustPackage {
    pname = "gen";
    version = "1.0.0";
    inherit src;

    cargoLock.lockFile = "${src}/Cargo.lock";

    meta = with lib; {
      description = "An extensible project generator";
      homepage = "https://github.com/NewDawn0/gen";
      maintainers = with maintainers; [NewDawn0];
      license = licenses.mit;
    };
  }
