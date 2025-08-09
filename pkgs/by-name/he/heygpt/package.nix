{
  fetchFromGitHub,
  lib,
  openssl,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "heygpt";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "fuyufjh";
    repo = "heygpt";
    rev = "v${version}";
    hash = "sha256-oP0yIdYytXSsbZ2pNaZ8Rrak1qJsudTe/oP6dGncGUM=";
  };

  cargoHash = "sha256-z5Y/dhDEAd6JcWItlGyH+kDxHxIiyJw0KrjiTDT+Fwc=";

  nativeBuildInputs = [ openssl ];

  # Needed to get openssl-sys to use pkg-config.
  OPENSSL_NO_VENDOR = 1;
  OPENSSL_LIB_DIR = "${lib.getLib openssl}/lib";
  OPENSSL_DIR = "${lib.getDev openssl}";

  meta = {
    description = "Simple command-line interface for ChatGPT API";
    homepage = "https://github.com/fuyufjh/heygpt";
    changelog = "https://github.com/fuyufjh/heygpt/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "heygpt";
    maintainers = with lib.maintainers; [ aldoborrero ];
  };
}
