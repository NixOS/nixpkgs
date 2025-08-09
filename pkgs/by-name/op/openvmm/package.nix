{
  lib,
  fetchFromGitHub,
  rustPlatform,
  pkg-config,
  openssl,
  protobuf,
}:

rustPlatform.buildRustPackage {
  pname = "openvmm";
  version = "0-unstable-2025-03-13";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "openvmm";
    rev = "047fde8a2b3eec17a46203fbc54ce7f3aa9b4dfd";
    hash = "sha256-w6MxJVm5/ABU04MZUCSjzHVZLXQIsOVCIJZkHOfxQC0=";
  };

  separateDebugInfo = true;

  env = {
    # Needed to get openssl-sys to use pkg-config.
    OPENSSL_NO_VENDOR = 1;
    PROTOC = "protoc";
  };
  nativeBuildInputs = [
    pkg-config
    protobuf
  ];
  buildInputs = [
    openssl
  ];

  cargoHash = "sha256-u0E09yFssd71wUS1BD766ztDImauu90T/jIWOb2v0mE=";

  meta = with lib; {
    homepage = "https://github.com/microsoft/openvmm";
    description = "Modular, cross-platform Virtual Machine Monitor (VMM), written in Rust";
    license = licenses.mit;
    mainProgram = "openvmm";
    maintainers = with maintainers; [ astro ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
}
