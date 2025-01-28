{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "comrak";
  version = "0.34.0";

  src = fetchFromGitHub {
    owner = "kivikakk";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-8LBMyCmt4HTYgprChfPSFZm6uQ7yFmJ0+srAUz785MA=";
  };

  cargoHash = "sha256-Z2LNFlHWS3IdjXlwdIizkjNFaPqTbMf0i6Y6jigKCzg=";

  meta = with lib; {
    description = "CommonMark-compatible GitHub Flavored Markdown parser and formatter";
    mainProgram = "comrak";
    homepage = "https://github.com/kivikakk/comrak";
    changelog = "https://github.com/kivikakk/comrak/blob/v${version}/changelog.txt";
    license = licenses.bsd2;
    maintainers = with maintainers; [
      figsoda
      kivikakk
    ];
  };
}
