{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
}:

buildNpmPackage rec {
  pname = "marp-cli";
  version = "4.1.1";

  src = fetchFromGitHub {
    owner = "marp-team";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-hgpkDcL2F1iNAoSqZzdEemUC5AGn4Xvt47km00ivemk=";
  };

  npmDepsHash = "sha256-jX+hDBgPdDtHPct6l/COdy0iTabPjVvvQ2CuKTB/mnk=";
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
