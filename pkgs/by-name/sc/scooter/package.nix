{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "scooter";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "thomasschafer";
    repo = "scooter";
    rev = "v${version}";
    hash = "sha256-dojVVBdXBtWvD/YIfouRmnsf1AWgfB3CYjH2KhtCsvI=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-yQhnN1GoosUx8YjUJsjtg2okDbSOFx0sUV26ggRDGI8=";

  meta = {
    description = "Interactive find and replace in the terminal";
    homepage = "https://github.com/thomasschafer/scooter";
    changelog = "https://github.com/thomasschafer/scooter/commits/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ felixzieger ];
    mainProgram = "scooter";
  };
}
