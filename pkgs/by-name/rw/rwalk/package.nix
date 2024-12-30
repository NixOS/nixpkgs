{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  stdenv,
  darwin,
}:

rustPlatform.buildRustPackage rec {
  pname = "rwalk";
  version = "0.8.7";

  src = fetchFromGitHub {
    owner = "cestef";
    repo = "rwalk";
    tag = "v${version}";
    hash = "sha256-rEecl8KdPqPreCRq8CZCBfpedInYD7+gfCwCst+VS90=";
  };

  cargoHash = "...";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs =
    [
      openssl
    ];

  env = {
    OPENSSL_NO_VENDOR = true;
  };

  meta = {
    description = "A blazingly fast web directory scanner written in Rust";
    homepage = "https://github.com/cestef/rwalk";
    changelog = "https://github.com/cestef/rwalk/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pwnwriter ];
    mainProgram = "rwalk";
  };
}
