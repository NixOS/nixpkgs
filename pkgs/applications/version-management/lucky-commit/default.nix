{ lib
, rustPlatform
, fetchFromGitHub
, withOpenCL ? true
, stdenv
, OpenCL
, ocl-icd
}:

rustPlatform.buildRustPackage rec {
  pname = "lucky-commit";
  version = "2.2.3";

  src = fetchFromGitHub {
    owner = "not-an-aardvark";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-jxcsTtQcSuL+2vwdxIVxqTpKh8Bfvna+hkGt+Rx21FE=";
  };

  cargoHash = "sha256-8JkodGtMdYP/IIBqRcJFD5syiZi+VakDyX7VcvR0HLo=";

  buildInputs = lib.optional withOpenCL (if stdenv.hostPlatform.isDarwin then OpenCL else ocl-icd);

  buildNoDefaultFeatures = !withOpenCL;

  # disable tests that require gpu
  checkNoDefaultFeatures = true;

  meta = with lib; {
    description = "Change the start of your git commit hashes to whatever you want";
    homepage = "https://github.com/not-an-aardvark/lucky-commit";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "lucky_commit";
  };
}
