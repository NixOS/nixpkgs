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
  version = "4.2.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "nickgerace";
    repo = pname;
    rev = version;
    sha256 = "sha256-cH4FhXrdT0ejpyt8G2rSGw9WE9sfOXRkSA9+FVwRmtQ=";
  };

  cargoSha256 = "sha256-NmVmqBzRUdumWQ9MzolZTo0VQW9JTjIyYRwUTzGiQZ4=";

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
