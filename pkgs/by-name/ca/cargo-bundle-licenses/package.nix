{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-bundle-licenses";
  version = "3.1.0";

  src = fetchFromGitHub {
    owner = "sstadick";
    repo = "cargo-bundle-licenses";
    rev = "v${version}";
    hash = "sha256-leSHjl/B76Z4JM1wO9IBKbdfMgHtY/pGut1hnDd8/L0=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-I5zIrMZ9GnlAUfWaaFP6yr+pv8wWtxguxSL0zho3BRs=";

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
