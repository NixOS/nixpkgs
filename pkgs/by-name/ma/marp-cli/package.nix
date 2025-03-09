{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
}:

buildNpmPackage rec {
  pname = "marp-cli";
  version = "4.1.2";

  src = fetchFromGitHub {
    owner = "marp-team";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-T3VZEXk3bhr17/BWlBx9beEbNhG2y/AnNf7+a1Adi2k=";
  };

  npmDepsHash = "sha256-TpVv+uMqLq1ynVWDOnrA2O+TksRDJva0K4hRltWb+SA=";
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
