{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "carto";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "mapbox";
    repo = "carto";
    rev = "v${version}";
    hash = "sha256-TylMgb2EI52uFmVeMJiQltgNCSh6MutFwUjsYC7gfEA=";
  };

  npmDepsHash = "sha256-8M9hze71bQWhyxcXeI/EOr0SQ+tx8Lb9LfvnGxYYo0A=";

  dontNpmBuild = true;

  meta = {
    changelog = "https://github.com/mapbox/carto/blob/${src.rev}/CHANGELOG.md";
    description = "Mapnik stylesheet compiler";
    homepage = "https://github.com/mapbox/carto";
    license = lib.licenses.asl20;
    mainProgram = "carto";
    maintainers = with lib.maintainers; [ Luflosi ];
  };
}
