{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "grunt-cli";
  version = "1.5.0";

  src = fetchFromGitHub {
    owner = "gruntjs";
    repo = "grunt-cli";
    tag = "v${version}";
    hash = "sha256-t1J6JLrY2H6ND/T2sl/3/6BZf4nFbUJs1dYvknRbs5s=";
  };

  postPatch = ''
    ln -s ${./package-lock.json} package-lock.json
  '';

  npmDepsHash = "sha256-SJmgMDw+BBm6NGUzFD4q5PVAZvYXelpM1d20xvL9U9c=";

  dontNpmBuild = true;

  meta = {
    description = "The grunt command line interface";
    homepage = "https://github.com/gruntjs/grunt-cli";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ onny ];
    mainProgram = "grunt";
  };
}
