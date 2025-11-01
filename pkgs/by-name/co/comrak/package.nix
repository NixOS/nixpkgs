{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "comrak";
  version = "0.45.0";

  src = fetchFromGitHub {
    owner = "kivikakk";
    repo = "comrak";
    rev = "v${version}";
    sha256 = "sha256-+87K5ITDrF/nH1H4z8zyqQlJnviOlRdNnV8v6xsS0uM=";
  };

  cargoHash = "sha256-efUiKSEsD+GguhriTpLmsyUxpQYzwr4rHJAC9FHMzdU=";

  meta = {
    description = "CommonMark-compatible GitHub Flavored Markdown parser and formatter";
    mainProgram = "comrak";
    homepage = "https://github.com/kivikakk/comrak";
    changelog = "https://github.com/kivikakk/comrak/blob/v${version}/changelog.txt";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [
      kivikakk
    ];
  };
}
