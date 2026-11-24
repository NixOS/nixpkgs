{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  testers,
  bibtex-tidy,
}:

buildNpmPackage rec {
  pname = "bibtex-tidy";
  version = "1.15.1";

  src = fetchFromGitHub {
    owner = "FlamingTempura";
    repo = "bibtex-tidy";
    rev = "v${version}";
    hash = "sha256-iCdLxQJZsMPRzEAB1uiuxNWu+urrP88Z6qhHQj/xSFs=";
  };

  npmDepsHash = "sha256-0nxqPpKM54MApd6X9/U7Eo/qnr0ya4BXi8OnsWDXha8=";

  passthru.tests = {
    version = testers.testVersion {
      package = bibtex-tidy;
      version = "v${version}";
    };
  };

  meta = {
    changelog = "https://github.com/FlamingTempura/bibtex-tidy/blob/${src.rev}/CHANGELOG.md";
    description = "Cleaner and Formatter for BibTeX files";
    mainProgram = "bibtex-tidy";
    homepage = "https://github.com/FlamingTempura/bibtex-tidy";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bertof ];
  };
}
