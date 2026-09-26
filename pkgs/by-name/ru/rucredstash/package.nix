{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "rucredstash";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "psibi";
    repo = "rucredstash";
    rev = "v${finalAttrs.version}";
    hash = "sha256-trupBiinULzD8TAy3eh1MYXhQilO08xu2a4yN7wwhwk=";
  };

  cargoHash = "sha256-QylZkqE8my2ldCjtg3++6TTDm0om3SVp0jwYUZ9qVes=";

  # Disable tests since it requires network access and relies on the
  # presence of certain AWS infrastructure
  doCheck = false;

  meta = {
    description = "Utility for managing credentials securely in AWS cloud";
    homepage = "https://github.com/psibi/rucredstash";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ psibi ];
    mainProgram = "rucredstash";
  };
})
