{
  fetchFromGitHub,
  gfold,
  lib,
  rustPlatform,
  testers,
}:

let
  pname = "gfold";
  version = "2025.4.0";
in
rustPlatform.buildRustPackage {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "nickgerace";
    repo = "gfold";
    rev = version;
    hash = "sha256-7PnqhS80Ozh5ZQNQ8iYgCiFT0JDLzhA09NV1HgrCOww=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-nGHJ96jFqG1pe3WUILPzm52HxrZYde2Z1p8N4DTaxlw=";

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
