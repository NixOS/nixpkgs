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
  version = "0.10.6";

  src = fetchFromGitHub {
    owner = "Watfaq";
    repo = "clash-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ncMJxVNHAgeXWhqZgWt3nth4BXqrrBaAEWmOVF/KsPg=";
  };

  patches = [
    # Remove the `npm ci` call in build.rs as it fails.
    ./skip-npm-ci.patch
  ];

  cargoHash = "sha256-WI+wg6cu0cBFrZYyN3GXlfHOmo/cVo2uMLn1D5YTOCQ=";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/clash-dashboard";
    hash = "sha256-8fDeO7Yx+m2s0mzTO7MkQOQ0UYs8B2vFnNevHHZFghc=";
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
    # requires features: sync_unsafe_cell, unbounded_shifts, let_chains, ip, if_let_guard
    RUSTC_BOOTSTRAP = 1;
    RUSTFLAGS = "-Zcrate-attr=feature(if_let_guard)";
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
