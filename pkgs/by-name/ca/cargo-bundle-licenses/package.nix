{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bundle-licenses";
  version = "4.2.0";

  src = fetchFromGitHub {
    owner = "sstadick";
    repo = "cargo-bundle-licenses";
    rev = "v${version}";
    hash = "sha256-L3hmgDwzL6lLa0LCg/V5QeNK2U1u2dJMO4+t6W1UvxI=";
  };

  cargoHash = "sha256-HHBFT4u0NPjhKJa3KNg8/AgkgNoFUkMWmioVaXYlD2M=";

  meta = with lib; {
    description = "Generate a THIRDPARTY file with all licenses in a cargo project";
    mainProgram = "cargo-bundle-licenses";
    homepage = "https://github.com/sstadick/cargo-bundle-licenses";
    changelog = "https://github.com/sstadick/cargo-bundle-licenses/blob/${src.rev}/CHANGELOG.md";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [
      matthiasbeyer
    ];
  };
}
