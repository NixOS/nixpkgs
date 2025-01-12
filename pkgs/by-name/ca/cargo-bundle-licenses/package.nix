{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bundle-licenses";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "sstadick";
    repo = "cargo-bundle-licenses";
    rev = "v${version}";
    hash = "sha256-oyb5uWIKXhPSMpb1t6C/IYKK8FMSANIQXs2XdJ/bD2A=";
  };

  cargoHash = "sha256-HxFRHgb0nBF6YGaiynv95fNwej70IAwP4jhVcGvdFok=";

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
      figsoda
      matthiasbeyer
    ];
  };
}
