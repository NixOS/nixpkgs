{
  lib,
  fetchFromGitHub,
  rustPlatform,
  protobuf,
  versionCheckHook,
  cmake,
  pkg-config,
  nix-update-script,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "clash-rs";
  version = "0.9.1";

  src = fetchFromGitHub {
    owner = "Watfaq";
    repo = "clash-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-asD7veAYdIF5biCbSXYvAyW/qBra3tvON9TQYCw6nB8=";
  };

  cargoHash = "sha256-9zCQKxkjiskkBGxfnq2ANpqWobs+UJ5qCsbME2Z7GY4=";

  cargoPatches = [ ./Cargo.patch ];

  patches = [
    ./unbounded-shifts.patch
  ];

  postPatch = ''
    substituteInPlace clash-lib/Cargo.toml \
      --replace-fail ', git = "https://github.com/smoltcp-rs/smoltcp.git", rev = "ac32e64"' ""
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    rustPlatform.bindgenHook
  ];

  nativeInstallCheckInputs = [
    protobuf
    versionCheckHook
  ];

  env = {
    # requires features: sync_unsafe_cell, unbounded_shifts, let_chains, ip
    RUSTC_BOOTSTRAP = 1;
    RUSTFLAGS = "--cfg tokio_unstable";
    NIX_CFLAGS_COMPILE = "-Wno-error";
  };

  buildFeatures = [ "plus" ];

  doCheck = false; # test failed

  postInstall = ''
    # Align with upstream
    ln -s "$out/bin/clash-rs" "$out/bin/clash"
  '';

  doInstallCheck = true;
  versionCheckProgramArg = "--version";

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
