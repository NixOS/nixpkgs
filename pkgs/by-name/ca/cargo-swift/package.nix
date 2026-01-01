{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-swift";
<<<<<<< HEAD
  version = "0.10.0";
=======
  version = "0.9.0";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "antoniusnaumann";
    repo = "cargo-swift";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-koHQaYfMDc8GxQ+K7C1YluMY5u4cUGV8/Ehjt/KWl/g=";
  };

  cargoHash = "sha256-8aFISZ2nzCmxxKkX77jEOE/MWcKwyTw8IGTEbJ0mKWg=";

  meta = {
    description = "Cargo plugin to easily build Swift packages from Rust code";
    mainProgram = "cargo-swift";
    homepage = "https://github.com/antoniusnaumann/cargo-swift";
    license = with lib.licenses; [
      asl20
      mit
    ];
    maintainers = with lib.maintainers; [ elliot ];
=======
    hash = "sha256-D6s25pOMdVZXBtBce/KEvqwn/9owrmxDOev3E59qrQ8=";
  };

  cargoHash = "sha256-pypBvfVW7m9dAvrc9ftrBOJ/wC+xLUuhGr7g7DVdZDI=";

  meta = with lib; {
    description = "Cargo plugin to easily build Swift packages from Rust code";
    mainProgram = "cargo-swift";
    homepage = "https://github.com/antoniusnaumann/cargo-swift";
    license = with licenses; [
      asl20
      mit
    ];
    maintainers = with maintainers; [ elliot ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
