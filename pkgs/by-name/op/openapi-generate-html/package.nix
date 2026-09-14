{ buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "openapi-generate-html";
  version = "0.5.3";

  src = fetchFromGitHub {
    owner = "qazsato";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-+RmwoRhvfkaj/d3EwID7E6noVV+M3h6pe7IEVYyuUwk=";
  };

  dontNpmBuild = true;

  npmDepsHash = "sha256-7yYM43fAR2HLACOQNw7N/t8Lk+17qNfeDKzfb1wx/0U=";

  __structuredAttrs = true;
}
