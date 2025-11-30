{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nodejs,
}:

buildNpmPackage rec {
  pname = "marp-cli";
  version = "4.2.3";

  src = fetchFromGitHub {
    owner = "marp-team";
    repo = "marp-cli";
    rev = "v${version}";
    hash = "sha256-CvQq9qndD9S/9t8UBpewQsW83CfV3BXftfFgFZ5Lttk=";
  };

  npmDepsHash = "sha256-VbpseSPH8uncCWiHtXBvCBARflXCCVTltmLO4uB8qmc=";
  npmPackFlags = [ "--ignore-scripts" ];
  makeCacheWritable = true;

  doCheck = false;

  meta = with lib; {
    description = "About A CLI interface for Marp and Marpit based converters";
    homepage = "https://github.com/marp-team/marp-cli";
    license = licenses.mit;
    maintainers = [ ];
    platforms = nodejs.meta.platforms;
    mainProgram = "marp";
  };
}
