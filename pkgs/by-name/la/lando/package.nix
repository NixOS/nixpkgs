{ lib, buildNpmPackage, fetchFromGitHub, nodejs }:

buildNpmPackage rec {
  pname = "lando";
  version = "3.21.0-beta.9";

  src = fetchFromGitHub {
    owner = "lando";
    repo = "cli";
    rev = "v${version}";
    sha256 = "pdOMNZmDGs0FhYwiTA8BVQVUO1zITygao9WcLAEiUFs=";
  };

  npmDepsHash = "sha256-+TJt4Fl536o6aLOB4pL5xDz2HnR1DdNC6iI4FxYzzuo=";
  dontNpmBuild = true;

  installPhase = ''
    mkdir -p $out/
    cp -R . $out/
  '';

  meta = with lib; {
    description = "A Liberating Dev Tool For All Your Projects";
    homepage = "https://lando.dev/";
    changelog = "https://github.com/lando/lando/blob/v${version}/CHANGELOG.md";
    license = licenses.gpl3;
    platforms = nodejs.meta.platforms;
    mainProgram = "lando";
  };
}
