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
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "Watfaq";
    repo = "clash-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-FFbRopIaAOpfb+Wbj+EUXRr89EQE108h8OMn+fpL+ew=";
  };

  cargoHash = "sha256-JYvITscH1K6xLE6XZpMrEFZWcbue7x7xuPxVQW/Vjb0=";

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
