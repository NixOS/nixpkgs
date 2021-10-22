{ lib
, rustPlatform
, fetchFromGitHub
, withOpenCL ? true
, ocl-icd
}:

rustPlatform.buildRustPackage rec {
  pname = "lucky-commit";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "not-an-aardvark";
    repo = pname;
    rev = "v${version}";
    sha256 = "0vs668i1yglfcqs94jhwdk90v0lja2w5kr5gakz082wykilms0zg";
  };

  cargoSha256 = "sha256-MvopLKhovwXaEmRgXnAzJeuhPgqnMjt0EtKUGSWFpaY=";

  buildInputs = lib.optional withOpenCL [ ocl-icd ];

  cargoBuildFlags = lib.optional (!withOpenCL) "--no-default-features";

  # disable tests that require gpu
  cargoTestFlags = [ "--no-default-features" ];

  meta = with lib; {
    description = "Change the start of your git commit hashes to whatever you want";
    homepage = "https://github.com/not-an-aardvark/lucky-commit";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "lucky_commit";
  };
}
