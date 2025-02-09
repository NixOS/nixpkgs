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
  version = "2.2.2";

  src = fetchFromGitHub {
    owner = "not-an-aardvark";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-DrgZBzcJmqSP7iCHZyy623iRZYfTE/z/zzx7I+BAOBo=";
  };

  cargoHash = "sha256-5P0CiLCf86Jul4EaIDqHGkp4XNifLKnWJZXtrLkpLMY=";

  buildInputs = lib.optional withOpenCL (if stdenv.isDarwin then OpenCL else ocl-icd);

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
