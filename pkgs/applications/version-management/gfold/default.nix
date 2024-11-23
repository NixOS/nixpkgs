{
  fetchFromGitHub,
  gfold,
  lib,
  rustPlatform,
  testers,
}:

let
  pname = "gfold";
  version = "4.5.1";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "nickgerace";
    repo = pname;
    rev = version;
    hash = "sha256-lIEYz5ngARzpJ4I1iN2bGd4eha1BiSmREJG6Cy2Lqrs=";
  };

  cargoHash = "sha256-9/Ro5aYKJCJ+5wvv6PmfWMrhYfc3a3d0DAhGDwMrvq4=";

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
