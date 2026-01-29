{
  lib,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
}:

rustPlatform.buildRustPackage rec {
  pname = "eludris";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "eludris";
    repo = "eludris";
    rev = "v${version}";
    hash = "sha256-TVYgimkGUSITB3IaMlMd10PWomqyJRvONvJwiW85U4M=";
  };

  cargoHash = "sha256-JpXjnkZHz12YxgTSqTcWdQTkrMugP7ZGw48145BeBZk=";

  cargoBuildFlags = [
    "--package"
    "eludris"
  ];
  cargoTestFlags = [
    "--package"
    "eludris"
  ];
  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  meta = {
    description = "Simple CLI to help you with setting up and managing your Eludris instance";
    mainProgram = "eludris";
    homepage = "https://github.com/eludris/eludris/tree/main/cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ooliver1 ];
  };
}
