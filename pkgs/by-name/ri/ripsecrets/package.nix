{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ripsecrets";
  version = "0.1.11";

  src = fetchFromGitHub {
    owner = "sirwart";
    repo = "ripsecrets";
    rev = "v${finalAttrs.version}";
    hash = "sha256-JCImUgicoXII64rK/Hch/0gJQE81Fw3h512w/vHUwAI=";
  };

  cargoHash = "sha256-2HsUNN3lyGb/eOUEN/vTOQbAy59DQSzIaOqdk9+KhfU=";

  meta = {
    description = "Command-line tool to prevent committing secret keys into your source code";
    homepage = "https://github.com/sirwart/ripsecrets";
    changelog = "https://github.com/sirwart/ripsecrets/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "ripsecrets";
  };
})
