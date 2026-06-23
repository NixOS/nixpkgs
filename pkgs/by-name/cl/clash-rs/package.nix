{
  lib,
  fetchFromGitHub,
  rustPlatform,
  protobuf,
  versionCheckHook,
  cmake,
  pkg-config,
  nodejs,
  fetchNpmDeps,
  npmHooks,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "clash-rs";
  version = "0.10.7";

  src = fetchFromGitHub {
    owner = "Watfaq";
    repo = "clash-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tY/GB6J8kr6Ni9ScOpKkDYLaLffvtaIxH8tXK24LHt8=";
  };

  patches = [
    # Remove the `npm ci` call in build.rs as it fails.
    ./skip-npm-ci.patch
  ];

  cargoHash = "sha256-SlkqNu6Vk1D9aU4GgyNDW9Or3z8KSbEjwCUK9w3Jyx0=";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/clash-dashboard";
    hash = "sha256-H8G3GuEh4JXZV1zxTfo89tl6D6WA5hWGOF9i8qP0njw=";
  };

  npmRoot = "clash-dashboard";

  nativeBuildInputs = [
    cmake
    pkg-config
    rustPlatform.bindgenHook
    nodejs
    npmHooks.npmConfigHook
  ];

  nativeInstallCheckInputs = [
    protobuf
    versionCheckHook
  ];

  env = {
    # requires nightly features: sync_unsafe_cell, unbounded_shifts, let_chains, ip
    RUSTC_BOOTSTRAP = 1;
    # if_let_guard is stable since Rust 1.95.0, but some deps still carry
    # the stale #![feature(if_let_guard)] attribute.
    RUSTFLAGS = "-A stable-features";
  };

  buildFeatures = [ "plus" ];

  doCheck = false; # test failed

  postInstall = ''
    # Align with upstream
    ln -s "$out/bin/clash-rs" "$out/bin/clash"
  '';

  doInstallCheck = true;

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex"
      "^v([0-9.]+)$"
    ];
  };

  meta = {
    description = "Custom protocol, rule based network proxy software";
    homepage = "https://github.com/Watfaq/clash-rs";
    mainProgram = "clash";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
