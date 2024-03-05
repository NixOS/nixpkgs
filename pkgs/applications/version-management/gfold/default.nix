{ fetchFromGitHub
, gitMinimal
, gfold
, lib
, libiconv
, makeWrapper
, rustPlatform
, Security
, stdenv
, testers
}:

let
  pname = "gfold";
  version = "4.4.1";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "nickgerace";
    repo = pname;
    rev = version;
    sha256 = "sha256-KKuWPitm7oD2mXPSu2rbOyzwJ9JJ23LBQIIkkPHm1w4=";
  };

  cargoHash = "sha256-wDUOYK9e0i600UnJ0w0FPI2GhTa/QTq/2+ICiDWrmEU=";

  buildInputs = lib.optionals stdenv.isDarwin [ libiconv Security ];

  passthru.tests.version = testers.testVersion {
    package = gfold;
    command = "gfold --version";
    inherit version;
  };

  meta = with lib; {
    description =
      "CLI tool to help keep track of your Git repositories, written in Rust";
    homepage = "https://github.com/nickgerace/gfold";
    license = licenses.asl20;
    maintainers = [ maintainers.shanesveller ];
    platforms = platforms.unix;
    mainProgram = "gfold";
  };
}
