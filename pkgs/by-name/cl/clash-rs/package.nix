{
  lib,
  fetchFromGitHub,
  rustPlatform,
  protobuf,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "clash-rs";
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "Watfaq";
    repo = "clash-rs";
    rev = "refs/tags/v${version}";
    hash = "sha256-5O+6uWAE45rH1vLwWlrNMGg0cenCptgKU5BCrKg+hM8=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-KqsZLV0MEt43FxlRuVY+bjlTmOs6Wu0OxNsQdVOjK/0=";

  env = {
    PROTOC = "${protobuf}/bin/protoc";
    # requires features: sync_unsafe_cell, unbounded_shifts, let_chains, ip
    RUSTC_BOOTSTRAP = 1;
  };

  doInstallCheck = true;

  dontCargoCheck = true; # test failed

  versionCheckProgramArg = "--version";

  nativeInstallCheckInputs = [ versionCheckHook ];

  buildFeatures = [
    "shadowsocks"
    "tuic"
    "onion"
  ];

  meta = {
    description = "Custom protocol, rule based network proxy software";
    homepage = "https://github.com/Watfaq/clash-rs";
    mainProgram = "clash-rs";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ aucub ];
    platforms = lib.platforms.linux;
  };
}
