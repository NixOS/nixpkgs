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
<<<<<<< HEAD
  version = "2.9.6";
=======
  version = "2.9.4";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "tauri-apps";
    repo = "tauri";
    tag = "tauri-cli-v${finalAttrs.version}";
<<<<<<< HEAD
    hash = "sha256-VtZxFkxOLMNwl3A/2qoNJ/HXr5FXFKQYw+ri5Yp8eOE=";
  };

  cargoHash = "sha256-uAjEQBHDpVv73MbeoU86tObiXSUKKjImpMTLHXKMRNs=";
=======
    hash = "sha256-A4Y9oRSzUP0Xm4BMXRzG1670GQk4yxxHJRkgIj5ExRg=";
  };

  cargoHash = "sha256-dOiqNmDYOzVadeoDefZauw0zSwuxnl3VO0KeKUJbx0E=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
