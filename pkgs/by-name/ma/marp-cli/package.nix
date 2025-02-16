{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
}:

buildNpmPackage rec {
  pname = "marp-cli";
  version = "4.1.0";

  src = fetchFromGitHub {
    owner = "marp-team";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-WuyDxfyWZNBBivlmztTnYNkL7P+P0yZpcLDu8nTDhhk=";
  };

  npmDepsHash = "sha256-JhsQz3A/RPEuGTbZeYaCEzBawSoD8p2u9agHBr4+hZU=";
  npmPackFlags = [ "--ignore-scripts" ];
  makeCacheWritable = true;

  doCheck = false;

  meta = with lib; {
    description = "About A CLI interface for Marp and Marpit based converters";
    homepage = "https://github.com/marp-team/marp-cli";
    license = licenses.mit;
    maintainers = with maintainers; [ GuillaumeDesforges ];
    platforms = nodejs.meta.platforms;
    mainProgram = "marp";
  };
}
