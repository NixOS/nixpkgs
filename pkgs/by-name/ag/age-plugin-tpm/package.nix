{
  lib,
  callPackage,
  buildGoModule,
  fetchFromGitHub,
  nixosTests,
  swtpm,
  openssl,
  age,
}:

buildGoModule rec {
  pname = "age-plugin-tpm";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "Foxboron";
    repo = "age-plugin-tpm";
    tag = "v${version}";
    hash = "sha256-yr1PSSmcUoOrQ8VMQEoaCLNvDO+3+6N7XXdNUyYVz9M=";
  };

  proxyVendor = true;

  vendorHash = "sha256-VEx6qP02QcwETOQUkMsrqVb+cOElceXcTDaUr480ngs=";

  nativeCheckInputs = [
    age
    swtpm
  ];

  buildInputs = [
    openssl
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  passthru.tests = {
    encrypt = callPackage ./tests/encrypt.nix { };
    decrypt = nixosTests.age-plugin-tpm-decrypt;
  };

  meta = with lib; {
    description = "TPM 2.0 plugin for age (This software is experimental, use it at your own risk)";
    mainProgram = "age-plugin-tpm";
    homepage = "https://github.com/Foxboron/age-plugin-tpm";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [
      kranzes
      sgo
    ];
  };
}
