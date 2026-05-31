{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "adguardian";
  version = "1.6.1";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Lissy93";
    repo = "AdGuardian-Term";
    tag = finalAttrs.version;
    hash = "sha256-jqjdYkB48ggLsmKlwiehkGHZ6EJhJYXGuVmZH7R0MlE=";
  };

  cargoHash = "sha256-ON3txhOQVuI3Th8FZ7yC4sd7L1fpYCD6XyIHbH5/Q4k=";

  meta = {
    description = "Terminal-based, real-time traffic monitoring and statistics for your AdGuard Home instance";
    mainProgram = "adguardian";
    homepage = "https://github.com/Lissy93/AdGuardian-Term";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
