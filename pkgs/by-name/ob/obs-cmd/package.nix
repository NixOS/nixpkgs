{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "obs-cmd";
  version = "0.18.1";

  src = fetchFromGitHub {
    owner = "grigio";
    repo = "obs-cmd";
    rev = "v${version}";
    hash = "sha256-+unUjGPDUSVGXyf91+mnPrLAslTpDxsCCmSnT34s7S0=";
  };

  cargoHash = "sha256-zEd8LUNZOspcrA90qJur6V2Dt/+9XJWvwBBjjFAPAg8=";

  meta = with lib; {
    description = "Minimal CLI to control OBS Studio via obs-websocket";
    homepage = "https://github.com/grigio/obs-cmd";
    changelog = "https://github.com/grigio/obs-cmd/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "obs-cmd";
  };
}
