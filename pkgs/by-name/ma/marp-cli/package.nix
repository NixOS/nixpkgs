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

<<<<<<< HEAD
  meta = {
    description = "About A CLI interface for Marp and Marpit based converters";
    homepage = "https://github.com/marp-team/marp-cli";
    license = lib.licenses.mit;
=======
  meta = with lib; {
    description = "About A CLI interface for Marp and Marpit based converters";
    homepage = "https://github.com/marp-team/marp-cli";
    license = licenses.mit;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    platforms = nodejs.meta.platforms;
    mainProgram = "marp";
  };
}
