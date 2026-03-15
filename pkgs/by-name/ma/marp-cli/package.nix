{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
}:

buildNpmPackage rec {
  pname = "marp-cli";
  version = "4.3.0";

  src = fetchFromGitHub {
    owner = "marp-team";
    repo = "marp-cli";
    rev = "v${version}";
    hash = "sha256-W/cXzSRUVPLfF/ajU6db6QmMcVdhMVCFk/E2l1zyhj8=";
  };

  npmDepsHash = "sha256-CbukMowG6hvhpHVvHoB83d/2mMNy2DGCNdhDcq3uzUQ=";
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
