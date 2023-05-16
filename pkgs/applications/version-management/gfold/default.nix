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
<<<<<<< HEAD
  version = "4.4.0";
=======
  version = "4.3.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "nickgerace";
    repo = pname;
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-2rBKf7+brd2NbukJYmeRpn7skxrLbMGYC9+VLqmdFfw=";
  };

  cargoHash = "sha256-7yPKZJKJF/ISfYfqpWLMApcNHqv3aFXL1a/cGtmbMVg=";
=======
    sha256 = "sha256-J7D/fwXhWgS6C9iJqdBaA0Ym7ioCbqmyI9BrmZfoEjY=";
  };

  cargoHash = "sha256-o7bUgm2SEDis6h+feUYE/Ew6pwbYCw/peRvb4c64TlM=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
