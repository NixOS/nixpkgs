{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "scooter";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "thomasschafer";
    repo = "scooter";
    rev = "v${version}";
    hash = "sha256-1BotQpkcw0RwPmHjQ/uoHKwerToxQ3OzHCvE/mbnSug";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-BN5h6IENeogkM79uZONNushEFLM/vw+QFyPjz1V1vVk";

  checkFlags = [
    # failed only for buildRustPackage
    # might be related to https://ryantm.github.io/nixpkgs/languages-frameworks/rust/#tests-relying-on-the-structure-of-the-target-directory
    "--skip=test_search_current_dir"
  ];

  meta = {
    description = "Interactive find and replace in the terminal";
    homepage = "https://github.com/thomasschafer/scooter";
    changelog = "https://github.com/thomasschafer/scooter/commits/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felixzieger ];
    mainProgram = "scooter";
  };
}
