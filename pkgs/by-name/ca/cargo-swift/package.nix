{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-swift";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "antoniusnaumann";
    repo = "cargo-swift";
    rev = "v${version}";
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
  };
}
