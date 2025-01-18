{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
}:

buildNpmPackage rec {
  pname = "marp-cli";
  version = "4.0.4";

  src = fetchFromGitHub {
    owner = "marp-team";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-gi9jkWuL63RRKR/X8yI3VBLdMaxWfYVDh0gAtuVHVv4=";
  };

  npmDepsHash = "sha256-ZThE92ZcIJToPuTU/7+uOeixLLx+C4jXMzmemSFjPh8=";
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
