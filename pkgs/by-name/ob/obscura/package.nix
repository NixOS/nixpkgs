{
  lib,
  callPackage,
  fetchFromGitHub,
  rustPlatform,
  openssl,
  pkg-config,
}:

let
  librusty_v8 = callPackage ./librusty_v8.nix { };
in
rustPlatform.buildRustPackage rec {
  pname = "obscura";
  __structuredAttrs = true;
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "h4ckf0r0day";
    repo = "obscura";
    rev = "v${version}";
    hash = "sha256-SCK9pDTODUNaTUb2yxe+cGNvQTMErWkFj5ZLu0dXYq8=";
  };

  cargoHash = "sha256-+q7KeXr69wv3SoJ5qTQOxomCGpA+JdoZ04Hv9jExiZU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ];

  # Tests SIGSEGV due to pre-built V8 library incompatibility in the sandbox
  # Tests segfault due to pre-built V8 binary incompatibility in the sandbox
  doCheck = false;

  env = {
    OPENSSL_NO_VENDOR = 1;
    RUSTY_V8_ARCHIVE = librusty_v8;
  };

  meta = with lib; {
    description = "Headless browser for AI agents and web scraping";
    homepage = "https://github.com/h4ckf0r0day/obscura";
    license = licenses.asl20;
    maintainers = with maintainers; [ dhogenson ];
    mainProgram = "obscura";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}
