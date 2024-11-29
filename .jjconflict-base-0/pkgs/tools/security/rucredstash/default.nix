{ lib, rustPlatform, fetchFromGitHub, stdenv, Security }:

rustPlatform.buildRustPackage rec {
  pname = "rucredstash";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "psibi";
    repo = "rucredstash";
    rev = "v${version}";
    hash = "sha256-trupBiinULzD8TAy3eh1MYXhQilO08xu2a4yN7wwhwk=";
  };

  cargoHash = "sha256-TYobVjjzrK3gprZcYyY98EvdASkq4urB+WiLlbJbwmk=";

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin Security;

  # Disable tests since it requires network access and relies on the
  # presence of certain AWS infrastructure
  doCheck = false;

  meta = with lib; {
    description = "Utility for managing credentials securely in AWS cloud";
    homepage = "https://github.com/psibi/rucredstash";
    license = licenses.mit;
    maintainers = with maintainers; [ psibi ];
    mainProgram = "rucredstash";
  };
}
