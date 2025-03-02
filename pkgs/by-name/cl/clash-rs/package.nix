{
  lib,
  fetchFromGitHub,
  rustPlatform,
  protobuf,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "clash-rs";
  version = "0.7.4";

  src = fetchFromGitHub {
    owner = "Watfaq";
    repo = "clash-rs";
    tag = "v${version}";
    hash = "sha256-PaXcMJuenUrcCBdU3CZEIk9U5tZxSAVVtm9ttAldVLM=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-ynGp1MU0l48mD+gfsyOFNo4jJDiDWgoPLc02WblPjt4=";

  nativeInstallCheckInputs = [
    protobuf
    versionCheckHook
  ];

  env = {
    # requires features: sync_unsafe_cell, unbounded_shifts, let_chains, ip
    RUSTC_BOOTSTRAP = 1;
  };

  buildFeatures = [
    "shadowsocks"
    "tuic"
    "onion"
  ];

  doCheck = false; # test failed

  postInstall = ''
    # Align with upstream
    ln -s "$out/bin/clash-rs" "$out/bin/clash"
  '';

  doInstallCheck = true;
  versionCheckProgramArg = "--version";

  meta = {
    description = "Custom protocol, rule based network proxy software";
    homepage = "https://github.com/Watfaq/clash-rs";
    mainProgram = "clash";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aaronjheng ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
