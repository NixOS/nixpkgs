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
  version = "0.10.10";

  src = fetchFromGitHub {
    owner = "Watfaq";
    repo = "clash-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RmxAi+0tgCAubwUTWv9w77yBdeIoEvYVxxyeHAe4Nbo=";
  };

  patches = [
    # Remove the `npm ci` call in build.rs as it fails.
    ./skip-npm-ci.patch
  ];

  cargoHash = "sha256-lJh/m6Ibgny1qFeeo3SDFJWXbZ/BX12/LX/m6g6RJZE=";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/clash-dashboard";
    hash = "sha256-WZjV7wcuQKCfe9aRN06wuId2Ql9wLB97e1SOCeLMIKo=";
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
