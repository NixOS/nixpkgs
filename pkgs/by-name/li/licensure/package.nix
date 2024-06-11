{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, openssl
, git
, gitls
}:
rustPlatform.buildRustPackage rec {
  pname = "licensure";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "chasinglogic";
    repo = "licensure";
    rev = version;
    hash = "sha256-1ncQjg/loYX9rAGP4FzI0ttd+GMPLkNPlJ6Xzb7umr0=";
  };

  cargoHash = "sha256-449p+y7qUcTxBOttyQPt+nRtK+s9HJBoVKGdMQaszLQ=";
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ openssl git gitls ];

  checkFlags = [
    # Checking for files in the git repo (git ls-files),
    # That obviously does not work with nix
    "--skip=test_get_project_files"
  ];

  meta = with lib; {
    description = "FOSS License management tool for your projects";
    homepage = "https://github.com/chasinglogic/licensure";
    license = licenses.gpl3Plus;
    mainProgram = "licensure";
    maintainers = [ maintainers.soispha ];
    platforms = platforms.linux;
  };
}
