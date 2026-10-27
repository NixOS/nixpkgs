{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage {
  pname = "jsonld-cli";
  version = "2.0.0-unstable-2026-03-23";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "digitalbazaar";
    repo = "jsonld-cli";
    rev = "ab35bc8b00dedcd119904f56a8904721188094b1";
    hash = "sha256-Bk89v4ze3Wquz+TA5WoTJmgG9W0a/L278QxegK3X0lU=";
  };

  npmDepsHash = "sha256-+cZX28z4aGlCQzVEBqbCNuwLhEkBjrK/gDkJ7vZdhUI=";

  dontNpmBuild = true;

  meta = {
    description = "JSON-LD command line interface tool";
    homepage = "https://github.com/digitalbazaar/jsonld-cli";
    changelog = "https://github.com/digitalbazaar/jsonld-cli/blob/ab35bc8b00dedcd119904f56a8904721188094b1/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ msladecek ];
    mainProgram = "jsonld";
  };
}
