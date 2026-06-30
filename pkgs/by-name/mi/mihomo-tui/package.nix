{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "mihomo-tui";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "potoo0";
    repo = "mihomo-tui";
    rev = "v${version}";
    hash = "sha256-8gWHExzt6f/enQSqgMUA5Y8fEwr7DXx0KfZw6d6xTp4=";
  };

  cargoHash = "sha256-NH4AX81kwwIAFlGBfPDBgDdLgKdgfnvYmMVzw9ry9D0=";

  cargoBuildFlags = [ "--locked" ];

  doCheck = false;
  RUSTFLAGS = "--cfg tokio_unstable";

  meta = {
    description = "A simple TUI dashboard for monitoring and managing Mihomo via its REST API";
    homepage = "https://github.com/potoo0/mihomo-tui";
    changelog = "https://github.com/potoo0/mihomo-tui/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      Oops418
    ];
    mainProgram = "mihomo-tui";
  };
}
