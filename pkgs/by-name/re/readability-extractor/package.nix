{ lib
, stdenv
, buildNpmPackage
, fetchFromGitHub
}:

buildNpmPackage {
  pname = "readability-extractor";
  version = "0.0.10";

  src = fetchFromGitHub {
    owner = "ArchiveBox";
    repo = "readability-extractor";
    rev = "be5c3222990d4f0459b21e74802565309bdd1d52";
    hash = "sha256-KX9mtvwDUIV2XsH6Hgx5/W34AlM4QtZuzxp4QofPcyg=";
  };

  dontNpmBuild = true;

  npmDepsHash = "sha256-bQHID9c2Ioyectx6t/GjTR/4cCyfwDfpT0aEQZoYCiU=";

  meta = with lib; {
    homepage = "https://github.com/ArchiveBox/readability-extractor";
    description = "Javascript wrapper around Mozilla Readability for ArchiveBox to call as a oneshot CLI to extract article text";
    license = licenses.mit;
    maintainers = with maintainers; [ viraptor ];
    mainProgram = "readability-extractor";
  };
}
