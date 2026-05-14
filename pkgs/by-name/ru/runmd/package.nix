{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "runmd";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "broofa";
    repo = "runmd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NaHBoRp6VuQwobpew7b1us8t2vbVPR4OLe3p3suykOw=";
  };

  npmDepsHash = "sha256-0djcoEq1O6zubD8OTFNE0BrOebSiw4JAXxa6flbHLb0=";

  dontNpmBuild = true;

  meta = {
    description = "Executable markdown files";
    homepage = "https://github.com/broofa/runmd";
    changelog = "https://github.com/broofa/runmd/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "runmd";
    platforms = lib.platforms.all;
  };
})
