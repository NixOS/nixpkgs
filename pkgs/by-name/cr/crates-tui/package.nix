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
  version = "0.1.20";
in
rustPlatform.buildRustPackage {
  pname = "crates-tui";
  inherit version;

  src = fetchFromGitHub {
    owner = "ratatui";
    repo = "crates-tui";
    rev = "refs/tags/v${version}";
    hash = "sha256-K3ttXoSS4GZyHnqS95op8kmbAi4/KjKa0P6Nzqqpjyw=";
  };

  cargoHash = "sha256-ztLBM6CR2WMKR9cfBY95BvSaD05C+AEa6C/nOdDxqf0=";

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
