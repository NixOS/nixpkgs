{
  lib,
  fetchFromGitHub,
  rustPlatform,
  aws-lc,
  sqlite,
  zstd,
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
  version = "0.10.11";

  src = fetchFromGitHub {
    owner = "Watfaq-legacy";
    repo = "clash-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-kGJ06U4Z7CETt0BI9JswEzYEPnSbt4oQH/n13anfvSc=";
  };

  patches = [
    # Remove the `npm ci` call in build.rs as it fails.
    ./skip-npm-ci.patch
  ];

  cargoHash = "sha256-adYPPjMaA4RmcbKm3PyPn3mO7zgfiVx1w3E3tRzACs4=";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/clash-dashboard";
    hash = "sha256-HdM2VyRBSDlTZiJ1iuclgdtAqAJiBbTTgioqnt7cdrM=";
  };

  npmRoot = "clash-dashboard";

  nativeBuildInputs = [
    cmake
    pkg-config
    rustPlatform.bindgenHook
    nodejs
    npmHooks.npmConfigHook
  ];

  buildInputs = [
    aws-lc
    sqlite
    zstd
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
    homepage = "https://github.com/Watfaq-legacy/clash-rs";
    mainProgram = "clash";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
