{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "scooter";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "thomasschafer";
    repo = "scooter";
    rev = "v${version}";
    hash = "sha256-TJgPBQEfoylSy0rwoN942Gigd16ZqIoi3lwdVTjXoOk=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-1sIzehv/TZQnkzTVM2Nog8UyOZcpaeBRR5CFaj/otL4=";

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
