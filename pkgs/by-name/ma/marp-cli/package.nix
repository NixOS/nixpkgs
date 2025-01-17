{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
}:

buildNpmPackage rec {
  pname = "marp-cli";
  version = "4.0.3";

  src = fetchFromGitHub {
    owner = "marp-team";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-HiLhFRQBCrDqMDX04gI7KolphA1ogTxdj1ehpL1D9e4=";
  };

  npmDepsHash = "sha256-8IN3MJBtq3Nu4T/WMcvg9QnckyigYhItBoGoSYOImTY=";
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
