{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "glob";
  version = "10.3.3";

  src = fetchFromGitHub {
    owner = "isaacs";
    repo = "node-glob";
    rev = "v${finalAttrs.version}";
    hash = "sha256-oLlNhQOnu/hlKjNWa5vjqslz1EarZJOpUEXUB+vGQvc=";
  };

  npmDepsHash = "sha256-78oODw+CBCk5JRJbDqLqVmzTVImP7Z7o6jRIimDxZDQ=";

  dontNpmBuild = true;

  meta = {
    changelog = "https://github.com/isaacs/node-glob/blob/${finalAttrs.src.rev}/changelog.md";
    description = "Little globber for Node.js";
    homepage = "https://github.com/isaacs/node-glob";
    license = lib.licenses.isc;
    mainProgram = "glob";
    maintainers = [ ];
  };
})
