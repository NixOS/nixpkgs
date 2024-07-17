{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "readability-extractor";
  version = "0.0.11";

  src = fetchFromGitHub {
    owner = "ArchiveBox";
    repo = "readability-extractor";
    rev = "refs/tags/v${version}";
    hash = "sha256-QzxwPonPrCDdVYHZ9rEfw8ok56lVZE82VykrfkdFh5I=";
  };

  dontNpmBuild = true;

  npmDepsHash = "sha256-F5lOGkhFlFVB8zTxrebWsPWRNfHgZ4Y2DqKED/z5riw=";

  meta = with lib; {
    homepage = "https://github.com/ArchiveBox/readability-extractor";
    description = "Javascript wrapper around Mozilla Readability for ArchiveBox to call as a oneshot CLI to extract article text";
    license = licenses.mit;
    maintainers = with maintainers; [ viraptor ];
    mainProgram = "readability-extractor";
  };
}
