{ fetchFromGitHub, lib, rustPlatform }:

rustPlatform.buildRustPackage rec {
  pname = "dutree";
  version = "0.2.18";

  src = fetchFromGitHub {
    owner = "nachoparker";
    repo = pname;
    rev = "v${version}";
    sha256 = "17lm8jd07bi499mywg2iq669im34j4x4yhc8a3adxn12f8j0dfg7";
    # test directory has files with unicode names which causes hash mismatches
    # It is also not used by any tests or parts of build process
    postFetch = ''
      rm -r $out/test
    '';
  };

  cargoHash = "sha256-/E+4yJEhZbERy4vOqn0Ruv3zOcd2FA+q41qZ0Tvg4T0=";

  meta = with lib; {
    description = "Tool to analyze file system usage written in Rust";
    homepage = "https://github.com/nachoparker/dutree";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "dutree";
  };
}
