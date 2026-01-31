{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "neve";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "MCB-SMART-BOY";
    repo = "Neve";
    rev = "v${version}";
    hash = "sha256-ICqAkj7JbQhnJ8U7kYs4EaA7k8hBVP0ZSqc9rWZrzhY=";
  };

  cargoHash = "sha256-c5SwgLMHEuXoR11QACUHnMy9paQsNFXLcoVQfXdrLQo=";

  cargoBuildFlags = [ "--package" "neve" ];
  cargoTestFlags = [ "--package" "neve" ];
  doCheck = false;

  nativeBuildInputs = [
    pkg-config
  ];

  meta = with lib; {
    description = "Pure functional language for system configuration and package management";
    homepage = "https://github.com/MCB-SMART-BOY/Neve";
    license = licenses.mpl20;
    mainProgram = "neve";
    platforms = platforms.unix;
  };
}
