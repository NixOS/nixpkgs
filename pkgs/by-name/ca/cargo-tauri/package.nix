{
  lib,
  stdenv,
  callPackage,
  rustPlatform,
  fetchFromGitHub,
  darwin,
  gtk3,
  libsoup,
  openssl,
  pkg-config,
  webkitgtk_4_0,
}:

rustPlatform.buildRustPackage rec {
  pname = "tauri";
  version = "1.7.1-unstable-2024-08-16";

  src = fetchFromGitHub {
    owner = "tauri-apps";
    repo = "tauri";
    rev = "2b61447dfc167ec11724f99671bf9e2de0bf6768";
    hash = "sha256-gKG7olZuTCkW+SKI3FVZqgS6Pp5hFemRJshdma8rpyg=";
  };

  # Manually specify the sourceRoot since this crate depends on other crates in the workspace. Relevant info at
  # https://discourse.nixos.org/t/difficulty-using-buildrustpackage-with-a-src-containing-multiple-cargo-workspaces/10202
  sourceRoot = "${src.name}/tooling/cli";

  cargoHash = "sha256-VXg/dAhwPTSrLwJm8HNzAi/sVF9RqgpHIF3PZe1LjSA=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      gtk3
      libsoup
      webkitgtk_4_0
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        CoreServices
        Security
        SystemConfiguration
      ]
    );

  passthru = {
    # See ./doc/hooks/tauri.section.md
    hook = callPackage ./hook.nix { };

    tests = {
      setupHooks = callPackage ./test-app.nix { };
    };
  };

  meta = {
    description = "Build smaller, faster, and more secure desktop applications with a web frontend";
    homepage = "https://tauri.app/";
    changelog = "https://github.com/tauri-apps/tauri/releases/tag/tauri-v${version}";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      dit7ya
      getchoo
      happysalada
    ];
    mainProgram = "cargo-tauri";
  };
}
