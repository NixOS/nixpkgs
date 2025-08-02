{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-ndk";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "bbqsrc";
    repo = "cargo-ndk";
    rev = "v${version}";
    sha256 = "sha256-laHRXy0eYDniDH9g0Bwnmd7NOSmuy+OFaqUd9YEsslc=";
  };

  cargoHash = "sha256-bppnSgwMGku6tRC9wxvOVaNGN8Jua64hPikzgk9SlYI=";

  meta = with lib; {
    description = "Cargo extension for building Android NDK projects";
    mainProgram = "cargo-ndk";
    homepage = "https://github.com/bbqsrc/cargo-ndk";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ mglolenstine ];
  };
}
