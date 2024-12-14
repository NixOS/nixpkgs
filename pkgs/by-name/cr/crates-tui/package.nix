{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  versionCheckHook,
  nix-update-script,
}:
let
  version = "0.1.23";
in
rustPlatform.buildRustPackage {
  pname = "crates-tui";
  inherit version;

  src = fetchFromGitHub {
    owner = "ratatui";
    repo = "crates-tui";
    rev = "refs/tags/v${version}";
    hash = "sha256-d5paevf7bFpC+dZ5fZ5n1F5yFtTWfqrGN4dTkwU0oLQ=";
  };

  cargoHash = "sha256-1E77Rz2MjR8NbLFO2oD7JWb5okLmV+/L5DBmHdPrwDg=";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "TUI for exploring crates.io using Ratatui";
    homepage = "https://github.com/ratatui/crates-tui";
    license = with lib.licenses; [ mit ];
    # See Cargo.toml: workspaces.metadata.dist.targets
    # Other platforms may work but YMMV
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
      "x86_64-windows"
    ];
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "crates-tui";
  };
}
