{
  lib,
  stdenv,
  callPackage,
  rustPlatform,
  fetchFromGitHub,
  gtk4,
  nix-update-script,
  openssl,
  pkg-config,
  webkitgtk_4_1,
}:

rustPlatform.buildRustPackage rec {
  pname = "tauri";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "tauri-apps";
    repo = "tauri";
    tag = "tauri-cli-v${version}";
    hash = "sha256-0J55AvAvvqTVls4474GcgLPBtSC+rh8cXVKluMjAVBE=";
  };

  cargoHash = "sha256-nkY1ydc2VewRwY+B5nR68mz8Ff3FK1KoHE4dLzNtPkY=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    gtk4
    webkitgtk_4_1
  ];

  cargoBuildFlags = [ "--package tauri-cli" ];
  cargoTestFlags = cargoBuildFlags;

  passthru = {
    # See ./doc/hooks/tauri.section.md
    hook = callPackage ./hook.nix { };

    tests = {
      hook = callPackage ./test-app.nix { };
    };

    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "tauri-cli-v(.*)"
      ];
    };
  };

  meta = {
    description = "Build smaller, faster, and more secure desktop applications with a web frontend";
    homepage = "https://tauri.app/";
    changelog = "https://github.com/tauri-apps/tauri/releases/tag/${src.tag}";
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
