{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-ndk";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "bbqsrc";
    repo = "cargo-ndk";
    rev = "v${version}";
    sha256 = "sha256-SKxRvSI2mocojRj8Xlv7933Fc/cH76Xv6LqYLXx3Sbg=";
  };

  cargoHash = "sha256-JrIlI26G4lUiJxpt0IrKDqgZwRHSQdF63enkBayGxXo=";

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
