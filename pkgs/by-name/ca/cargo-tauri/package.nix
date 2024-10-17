{
  lib,
  stdenv,
  callPackage,
  rustPlatform,
  fetchFromGitHub,
  cargo-tauri,
  darwin,
  gtk4,
  nix-update-script,
  openssl,
  pkg-config,
  testers,
  webkitgtk_4_1,
}:

rustPlatform.buildRustPackage rec {
  pname = "tauri";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "tauri-apps";
    repo = "tauri";
    rev = "refs/tags/tauri-v${version}";
    hash = "sha256-kHzpx1o894bo4Ud3D1lbB+pZahflF/o2bb2EDJUI148=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "schemars_derive-0.8.21" = "sha256-AmxBKZXm2Eb+w8/hLQWTol5f22uP8UqaIh+LVLbS20g=";
    };
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs =
    [ openssl ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      gtk4
      webkitgtk_4_1
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin (
      with darwin.apple_sdk.frameworks;
      [
        CoreServices
        Security
        SystemConfiguration
      ]
    );

  cargoBuildFlags = [ "--package tauri-cli" ];
  cargoTestFlags = cargoBuildFlags;

  passthru = {
    # See ./doc/hooks/tauri.section.md
    hook = callPackage ./hook.nix { };

    tests = {
      hook = callPackage ./test-app.nix { };
      version = testers.testVersion { package = cargo-tauri; };
    };

    updateScript = nix-update-script { };
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
