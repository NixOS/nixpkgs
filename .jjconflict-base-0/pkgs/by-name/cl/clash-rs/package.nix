{
  lib,
  fetchFromGitHub,
  rustPlatform,
  protobuf,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "clash-rs";
  version = "0.7.3";

  src = fetchFromGitHub {
    owner = "Watfaq";
    repo = "clash-rs";
    rev = "refs/tags/v${version}";
    hash = "sha256-SJ3NhLiDA0iRgq9pKB/CeltPE2ewbY+z1NBQriebNi0=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-XZd3dah6c0jg5en/7fHAXz8iSb7AMJPvPZViXHTdEbw=";

  env = {
    PROTOC = "${protobuf}/bin/protoc";
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

  nativeInstallCheckInputs = [
    versionCheckHook
  ];

  meta = {
    description = "Custom protocol, rule based network proxy software";
    homepage = "https://github.com/Watfaq/clash-rs";
    mainProgram = "clash";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}
