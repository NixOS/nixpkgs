{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "comrak";
  version = "0.36.0";

  src = fetchFromGitHub {
    owner = "kivikakk";
    repo = "comrak";
    rev = "v${version}";
    sha256 = "sha256-sT83t7YavXzUXaE9vSeg9AbLHl6Bq2BAZpEoClLRcmY=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-7fu2kZJ//Ysa5vUvn0wxNLmBsL5+++RRty0HTpHejws=";

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
