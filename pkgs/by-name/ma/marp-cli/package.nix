{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
}:

buildNpmPackage rec {
  pname = "marp-cli";
  version = "4.2.2";

  src = fetchFromGitHub {
    owner = "marp-team";
    repo = "marp-cli";
    rev = "v${version}";
    hash = "sha256-9ivc/LuadZLjxAfk9Q57uUVEEXGLbgwTjKdc/v8dDxo=";
  };

  npmDepsHash = "sha256-glIMWRHZV/5bt3LcWOQctZ4JoqKlmhWu85NyUr9aDLs=";
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
