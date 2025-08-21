{
  lib,
  stdenv,
  bzip2,
  callPackage,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
  pkg-config,
  testers,
  xz,
  zstd,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "tauri";
  version = "2.7.1";

  src = fetchFromGitHub {
    owner = "tauri-apps";
    repo = "tauri";
    tag = "tauri-cli-v${finalAttrs.version}";
    hash = "sha256-0J55AvAvvqTVls4474GcgLPBtSC+rh8cXVKluMjAVBE=";
  };

  cargoHash = "sha256-nkY1ydc2VewRwY+B5nR68mz8Ff3FK1KoHE4dLzNtPkY=";

  nativeBuildInputs = lib.optionals (stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isLinux) [
    pkg-config
  ];

  buildInputs =
    # Required for tauri-macos-sign and RPM support in tauri-bundler
    lib.optionals (stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isLinux) [
      bzip2
      xz
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      zstd
    ];

  cargoBuildFlags = [ "--package tauri-cli" ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  env = lib.optionalAttrs stdenv.hostPlatform.isLinux {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  passthru = {
    # See ./doc/hooks/tauri.section.md
    hook = callPackage ./hook.nix { cargo-tauri = finalAttrs.finalPackage; };

    tests = {
      hook = callPackage ./test-app.nix { cargo-tauri = finalAttrs.finalPackage; };
      version = testers.testVersion { package = finalAttrs.finalPackage; };
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
    changelog = "https://github.com/tauri-apps/tauri/releases/tag/tauri-cli-v${finalAttrs.version}";
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
})
