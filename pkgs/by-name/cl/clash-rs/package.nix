{
  lib,
  fetchpatch,
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
  version = "0.10.8";

  src = fetchFromGitHub {
    owner = "Watfaq";
    repo = "clash-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dnM8lHObjgYF/Wm0uD7LlYosZ+mSPNbaTDKyWU2sNvo=";
  };

  patches = [
    # Remove the `npm ci` call in build.rs as it fails.
    ./skip-npm-ci.patch

    # The shadowquic git patch in [patch.crates-io] is marked [[patch.unused]]
    # in Cargo.lock because registry 0.3.12 already carries the fix. In
    # offline/vendor mode cargo still tries to resolve the git source and
    # fails because only shadowquic-macros was vendored from that repo.
    # Also fixes watfaq-netstack version mismatch and release workflow.
    (fetchpatch {
      url = "https://github.com/Watfaq/clash-rs/commit/227255546187e509795b00c68d8cead738f1db7d.patch";
      hash = "sha256-WMu/mBL0Gcz4OJW6/16MwkxDPbt/ERu4+Mt+iJvagXo=";
    })
  ];

  # Keep the vendored Cargo.lock in sync with the patched source one.
  postPatch = ''
    sed -i '/^$/N;/^\n\[\[patch\.unused\]\]$/,$d' "$cargoDepsCopy/Cargo.lock"
    sed -i '/name = "watfaq-netstack"/{n;s/version = "0.1.1"/version = "0.1.0"/;}' "$cargoDepsCopy/Cargo.lock"
  '';

  cargoHash = "sha256-Gu4NkpU9GVGEsMVoGReiBYf9TEkEsznSsJTlZMK/1TY=";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/clash-dashboard";
    hash = "sha256-fL0PTkAtopysqXr1D8JmtQ7C77SGOBnpweRe02bn7jE=";
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
