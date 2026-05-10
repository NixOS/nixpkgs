{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
}:

buildNpmPackage rec {
  pname = "marp-cli";
  version = "4.4.0";

  src = fetchFromGitHub {
    owner = "marp-team";
    repo = "marp-cli";
    rev = "v${version}";
    hash = "sha256-DWXJ049pgrUFpacKObKURU8YrIl6Q4O4bXkzU35Dq00=";
  };

  npmDepsHash = "sha256-rIL5x6VLfT+mGqjE3yHQs1Dp0SZt7ZlhmC3dzSJXGRM=";
  npmPackFlags = [ "--ignore-scripts" ];
  makeCacheWritable = true;

  doCheck = false;

  meta = {
    description = "About A CLI interface for Marp and Marpit based converters";
    homepage = "https://github.com/marp-team/marp-cli";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = nodejs.meta.platforms;
    mainProgram = "marp";
  };
}
