{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  perl,
}:

rustPlatform.buildRustPackage rec {
  pname = "neve";
  version = "3.0.0";

  src = fetchFromGitHub {
    owner = "MCB-SMART-BOY";
    repo = "Neve";
    rev = "v${version}";
    hash = "sha256-1+9USxixmcH5WCG6PDm2bIcONmNCySBWf0Y/H1eKKK0=";
  };

  cargoHash = "sha256-TmJzCaImYJzkbIZAVy/ig4re94mG4X5oDGmBs3Y3xd8=";

  cargoBuildFlags = [
    "--package"
    "neve"
  ];
  cargoTestFlags = [
    "--package"
    "neve"
  ];
  doCheck = false;

  nativeBuildInputs = [
    pkg-config
    perl
  ];

  meta = with lib; {
    description = "Pure functional language for system configuration and package management";
    homepage = "https://github.com/MCB-SMART-BOY/Neve";
    license = licenses.mpl20;
    mainProgram = "neve";
    platforms = platforms.unix;
  };
}
