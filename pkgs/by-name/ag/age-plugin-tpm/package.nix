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
<<<<<<< HEAD
  version = "1.0.0";
=======
  version = "0.3.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "Foxboron";
    repo = "age-plugin-tpm";
    tag = "v${version}";
<<<<<<< HEAD
    hash = "sha256-Vr6simVW5nAWTa8Dro2gar2+O90T8u6h09wTnEnygss=";
=======
    hash = "sha256-yr1PSSmcUoOrQ8VMQEoaCLNvDO+3+6N7XXdNUyYVz9M=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  proxyVendor = true;

<<<<<<< HEAD
  vendorHash = "sha256-CbgDGyVQ9MTYCe56M1VzMnap5P6Y9p4jnK8tyr3zh20=";
=======
  vendorHash = "sha256-VEx6qP02QcwETOQUkMsrqVb+cOElceXcTDaUr480ngs=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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

<<<<<<< HEAD
  meta = {
    description = "TPM 2.0 plugin for age (This software is experimental, use it at your own risk)";
    mainProgram = "age-plugin-tpm";
    homepage = "https://github.com/Foxboron/age-plugin-tpm";
    license = lib.licenses.mit;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [
=======
  meta = with lib; {
    description = "TPM 2.0 plugin for age (This software is experimental, use it at your own risk)";
    mainProgram = "age-plugin-tpm";
    homepage = "https://github.com/Foxboron/age-plugin-tpm";
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      kranzes
      sgo
    ];
  };
}
