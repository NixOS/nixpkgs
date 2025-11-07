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
  version = "2.9.2";

  src = fetchFromGitHub {
    owner = "tauri-apps";
    repo = "tauri";
    tag = "tauri-cli-v${finalAttrs.version}";
    hash = "sha256-kkCeNQL5NR7DGKa3rbPx3NRQv1vAOHw741icHmzj5v8=";
  };

  cargoHash = "sha256-oTL/kwvuFio7RTnpVqeEXNsWCsNUKY8GlNlh+59LVxg=";

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
