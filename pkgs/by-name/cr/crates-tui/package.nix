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
  version = "0.1.24";
in
rustPlatform.buildRustPackage {
  pname = "crates-tui";
  inherit version;

  src = fetchFromGitHub {
    owner = "ratatui";
    repo = "crates-tui";
    tag = "v${version}";
    hash = "sha256-yAMVl+3DP9NCjHc9X0qOd6zlJvaY3kcvnVBSS8JHtgU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-/w3M5I9IOO2e37dnL8iE3LY5z1N07RkD3mMGJrswVMI=";

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
