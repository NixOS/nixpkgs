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
  version = "4.0.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "nickgerace";
    repo = pname;
    rev = version;
    sha256 = "1yh5173qhi9bd41zss9k21nm0xnr2sa918kvlyr5xvzhq47rrwz5";
  };

  cargoSha256 = "sha256-o2fMIlj+veTmhfqi7BVpxr3520SOwWLmVS2UU83EVjo=";

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
  };
}
