{
  fetchFromGitHub,
  gfold,
  lib,
  libiconv,
  rustPlatform,
  Security,
  stdenv,
  testers,
}:

let
  pname = "gfold";
  version = "4.5.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "nickgerace";
    repo = pname;
    rev = version;
    sha256 = "sha256-7wTU+yVp/GO1H1MbgZKO0OwqSC2jbHO0lU8aa0tHLTY=";
  };

  cargoHash = "sha256-idzw5dfCCvujvYr7DG0oOzQUIcbACtiIZLoA4MEClzY=";

  buildInputs = lib.optionals stdenv.isDarwin [
    libiconv
    Security
  ];

  passthru.tests.version = testers.testVersion {
    package = gfold;
    command = "gfold --version";
    inherit version;
  };

  meta = with lib; {
    description = "CLI tool to help keep track of your Git repositories, written in Rust";
    homepage = "https://github.com/nickgerace/gfold";
    license = licenses.asl20;
    maintainers = [ maintainers.sigmanificient ];
    platforms = platforms.unix;
    mainProgram = "gfold";
  };
}
