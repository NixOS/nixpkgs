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

  cargoHash = "sha256-zUeCthQ2fQ1P0gxN5XXg6a+Op8JFMrzU02Mh0mpwv30=";

  meta = {
    changelog = "https://github.com/antonWetzel/prettypst/blob/${src.rev}/changelog.md";
    description = "Formatter for Typst";
    homepage = "https://github.com/antonWetzel/prettypst";
    license = lib.licenses.mit;
    mainProgram = "prettypst";
    maintainers = with lib.maintainers; [ drupol ];
  };
}
