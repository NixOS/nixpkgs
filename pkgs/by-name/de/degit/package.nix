{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "degit";
  version = "2.8.4";

  src = fetchFromGitHub {
    owner = "Rich-Harris";
    repo = "degit";
    rev = "v${version}";
    hash = "sha256-Vw/gtmKywi5faSCs7Wek80nmnqcPHXlQarD5qMwlsQE=";
  };

  npmDepsHash = "sha256-42cM31C2c1Gr7HWOowMUTEUEyL0mGnyl5fyQECcz1Sw=";

  meta = {
    changelog = "https://github.com/Rich-Harris/degit/blob/${src.rev}/CHANGELOG.md";
    description = "Make copies of git repositories";
    homepage = "https://github.com/Rich-Harris/degit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kidonng ];
    mainProgram = "degit";
  };
}
