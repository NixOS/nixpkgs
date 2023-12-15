{ lib, buildNpmPackage, fetchFromGitHub }:

buildNpmPackage rec {
  pname = "inshellisense";
  version = "0.0.1-rc.4";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-PYSonVyclGSH3ArbqJuKrBNGbJaQEp6XemwnHboVwPk=";
  };

  npmDepsHash = "sha256-sjr4Hy1/zWPAlVGsMkyQIQcBT86KLaN2/UAaAd7Mn6Q=";

  meta = with lib; {
    description = "IDE style command line auto complete";
    homepage = "https://github.com/microsoft/inshellisense";
    license = licenses.mit;
    maintainers = [ maintainers.malo ];
  };
}

