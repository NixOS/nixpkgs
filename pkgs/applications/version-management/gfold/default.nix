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
  version = "4.3.3";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "nickgerace";
    repo = pname;
    rev = version;
    sha256 = "sha256-J7D/fwXhWgS6C9iJqdBaA0Ym7ioCbqmyI9BrmZfoEjY=";
  };

  cargoHash = "sha256-o7bUgm2SEDis6h+feUYE/Ew6pwbYCw/peRvb4c64TlM=";

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
