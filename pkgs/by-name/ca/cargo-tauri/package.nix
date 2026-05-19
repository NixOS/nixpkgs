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
  version = "2.11.0";

  src = fetchFromGitHub {
    owner = "tauri-apps";
    repo = "tauri";
    tag = "tauri-cli-v${finalAttrs.version}";
    hash = "sha256-hbTpLeWMc5nSJeq1vWKbVpfhp1KZjiBgmaiQMUs/MIQ=";
  };

  cargoHash = "sha256-PrvlPfK/9qyBWOs6hG3C3w9TMK7p1TCoKpjSWkhN2rY=";

  nativeBuildInputs = lib.optionals (stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isLinux) [
    pkg-config
  ];

  # Explicitly enable optional `rustls` dependency.
  postPatch = ''
    substituteInPlace crates/tauri/Cargo.toml \
      --replace-fail 'dep:rustls' 'rustls'
  '';

  buildInputs =
    # Required for tauri-macos-sign and RPM support in tauri-bundler
    lib.optionals (stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isLinux) [
      bzip2
      xz
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      zstd
    ];

  patches = [
    ./skip-icon-macos.patch
  ];

  cargoBuildFlags = [
    "--package"
    "tauri-cli"
  ];
  cargoTestFlags = finalAttrs.cargoBuildFlags;

  env = lib.optionalAttrs stdenv.hostPlatform.isLinux {
    ZSTD_SYS_USE_PKG_CONFIG = true;
  };

  passthru = {
    # See ./doc/hooks/tauri.section.md
    hook = callPackage ./hook.nix { cargo-tauri = finalAttrs.finalPackage; };
    gst-plugin = callPackage ./gst-plugin.nix { };

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
