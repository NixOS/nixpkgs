{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "prettypst";
  version = "unstable-2024-10-20";

  src = fetchFromGitHub {
    owner = "antonWetzel";
    repo = "prettypst";
    rev = "a724b56de0527faf0f1f1eecb17d0b847872411c";
    hash = "sha256-CVvcrytEG2q6kPiGBMfy/oQCD63Gm2AenvLUhCUx6fw=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-NxCc5DGbeHJ3M2V4h/u0lvzEkSbFU+rMcSnu+kJ0rXM=";

  meta = {
    changelog = "https://github.com/antonWetzel/prettypst/blob/${src.rev}/changelog.md";
    description = "Formatter for Typst";
    homepage = "https://github.com/antonWetzel/prettypst";
    license = lib.licenses.mit;
    mainProgram = "prettypst";
    maintainers = with lib.maintainers; [ drupol ];
  };
}
