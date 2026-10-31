{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage rec {
  pname = "glob";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "isaacs";
    repo = "glob-bin";
    rev = "v${version}";
    hash = "sha256-PW2XzV+vT9NlHAwE3JriEYqoZjsuJFXFk0SlfA/7dIw=";
  };

  npmDepsHash = "sha256-BJVDfld/EmeRxHlmPByaQ3BO3PyoeHhklEjztcHFTvg=";

  dontNpmBuild = true;

  meta = {
    changelog = "https://github.com/isaacs/node-glob/blob/${src.rev}/changelog.md";
    description = "Little globber for Node.js";
    homepage = "https://github.com/isaacs/node-glob";
    license = lib.licenses.blueOak100;
    mainProgram = "glob-bin";
    maintainers = [ lib.maintainers.kashw2 ];
  };
}
