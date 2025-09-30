{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-ndk";
  version = "4.1.2";

  src = fetchFromGitHub {
    owner = "bbqsrc";
    repo = "cargo-ndk";
    rev = "v${version}";
    sha256 = "sha256-1LtjBbfrHKgfqcwz40l7d4+d9C4vY/BKI2P2Oshk+a0=";
  };

  cargoHash = "sha256-QB4s6g3QmHFPtR7utGmfhQ8iUFyw6DXGii4XTj2V874=";

  meta = with lib; {
    description = "Cargo extension for building Android NDK projects";
    mainProgram = "cargo-ndk";
    homepage = "https://github.com/bbqsrc/cargo-ndk";
    license = with licenses; [
      asl20 # or
      mit
    ];
    maintainers = with maintainers; [ ];
  };
}
