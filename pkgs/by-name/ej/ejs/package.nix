{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
let
  version = "3.1.10";
in
buildNpmPackage {
  pname = "ejs";
  inherit version;

  src = fetchFromGitHub {
    owner = "mde";
    repo = "ejs";
    rev = "v${version}";
    hash = "sha256-3Rq+7oiYJlIY7sGPasx728sz2zj0ndAvKpHGsQX4tlc=";
  };

  npmDepsHash = "sha256-829eWfJiMw9KRlhdmzD0ha//bgUQ5nPEzO+ayUPLxXY=";

  buildPhase = ''
    runHook preBuild

    ./node_modules/.bin/jake build

    runHook postBuild
  '';

  meta = {
    description = "Embedded JavaScript templates";
    homepage = "https://ejs.co";
    license = lib.licenses.asl20;
    mainProgram = "ejs";
    maintainers = with lib.maintainers; [ momeemt ];
  };
}
