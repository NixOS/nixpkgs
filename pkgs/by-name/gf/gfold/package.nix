{
  fetchFromGitHub,
  gfold,
  lib,
  rustPlatform,
  testers,
  mold,
}:

let
  pname = "gfold";
  version = "2025.9.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "nickgerace";
    repo = "gfold";
    rev = version;
    hash = "sha256-sPvhZaDGInXH2PT8fg28m7wyDZiIE4fFScNO8WIjV9s=";
  };

  cargoHash = "sha256-pbIE8QXY8lYsDGdmGVsOPesVTaHRjDBSd7ihQhN2XrI=";

  nativeBuildInputs = [ mold ];

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
