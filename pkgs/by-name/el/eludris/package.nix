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
    repo = pname;
    rev = "v${version}";
    hash = "sha256-TVYgimkGUSITB3IaMlMd10PWomqyJRvONvJwiW85U4M=";
  };

  cargoHash = "sha256-5B9D19jFh5+eNTjiho22CFsn51nmwLry08zSDWvs1OU=";

  cargoBuildFlags = [ "-p eludris" ];
  cargoTestFlags = [ "-p eludris" ];
  buildInputs = [ openssl ];
  nativeBuildInputs = [ pkg-config ];

  meta = with lib; {
    description = "Simple CLI to help you with setting up and managing your Eludris instance";
    mainProgram = "eludris";
    homepage = "https://github.com/eludris/eludris/tree/main/cli";
    license = licenses.mit;
    maintainers = with maintainers; [ ooliver1 ];
  };
}
