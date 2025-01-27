{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bundle-licenses";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "sstadick";
    repo = "cargo-bundle-licenses";
    rev = "v${version}";
    hash = "sha256-Rw5uwfUPTkIbiOQDohBRoAm0momljJRSYP+VmEOOw/k=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-qG7pkgSMdWDlODPOaWHFhGkSyXP9kcrh/lK4CVGVOz8=";

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
