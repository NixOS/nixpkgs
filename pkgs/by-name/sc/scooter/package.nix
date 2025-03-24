{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "scooter";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "thomasschafer";
    repo = "scooter";
    rev = "v${version}";
    hash = "sha256-wu9SNcd1+JqTkhUghOiRlGP/za/9Md/lgGrwNA2lCJE=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-DQU3djlSjG1VG2bs+JuegwF3ii+asJXpEEPb95xeXqk=";

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
