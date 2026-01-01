{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage {
  pname = "regenkfs";
  version = "0-unstable-2020-10-17";

  src = fetchFromGitHub {
    owner = "siraben";
    repo = "regenkfs";
    rev = "652155445fc39bbe6628f6b9415b5cd6863f592f";
    sha256 = "sha256-zkwOpMNPGstn/y1l1s8blUKpBebY4Ta9hiPYxVLvG6Y=";
  };

  cargoHash = "sha256-H8ORNdIVwmtNfuxbyyf5F35tGLNUXwrTFE2CVgkxr0M=";

  buildFeatures = [ "c-undef" ];

<<<<<<< HEAD
  meta = {
    description = "Reimplementation of genkfs in Rust";
    homepage = "https://github.com/siraben/regenkfs";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ siraben ];
=======
  meta = with lib; {
    description = "Reimplementation of genkfs in Rust";
    homepage = "https://github.com/siraben/regenkfs";
    license = licenses.mit;
    maintainers = with maintainers; [ siraben ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "regenkfs";
  };
}
