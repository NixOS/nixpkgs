{
  lib,
  fetchFromGitHub,
  rustPlatform,
  protobuf,
  versionCheckHook,
}:
rustPlatform.buildRustPackage rec {
  pname = "clash-rs";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "Watfaq";
    repo = "clash-rs";
    rev = "refs/tags/v${version}";
    hash = "sha256-H76ErJQ+qKC3mt3IzNCPldAwlj7NnYUcLzUuOYykxnE=";
  };

  useFetchCargoVendor = true;

  cargoHash = "sha256-yU5ioAuCJRuYKNOdd381W07Ua+c2me+wHFOMukTVVqM=";

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
