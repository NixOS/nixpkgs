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
  version = "0.10.2";

  src = fetchFromGitHub {
    owner = "Watfaq";
    repo = "clash-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zv4HtydADD5e9hYsxIdPZ0fV0usMPYCeFC8PD5Yr0qU=";
  };

  cargoHash = "sha256-arPErfK4JiWzA30xQDI3p5gQGTOYi1DOWJLAbwfP+U0=";

  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-${finalAttrs.version}-npm-deps";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/clash-dashboard";
    hash = "sha256-+tPpYmeAUCK2lKuLVjgRt37mqvjqazOcTXFxVahIhxI=";
  };

  npmRoot = "clash-dashboard";

  makeCacheWritable = true;

  preBuild = ''
    # clash-lib/build.rs hardcodes the npm cache as $TMPDIR/npm-cache
    ln -sf "$npm_config_cache" "$TMPDIR/npm-cache"
  '';

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
    # requires features: sync_unsafe_cell, unbounded_shifts, let_chains, ip
    RUSTC_BOOTSTRAP = 1;
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
