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
  version = "0.9.7";

  src = fetchFromGitHub {
    owner = "Watfaq";
    repo = "clash-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-26OoAy/IiTEqESABqjLMI9zsmHgBbwmIazzoP8Au4nM=";
  };

  cargoHash = "sha256-UPCXc0uB0pg4ioBIpYQKwtyTWsMH/248WDyO9qB2jwA=";

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
