{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:

buildNpmPackage (finalAttrs: {
  pname = "runmd";
  version = "2.0.0";

  src = fetchFromGitHub {
    owner = "broofa";
    repo = "runmd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CPWY3GFRWlFtDtsZl77qOTuGDyokjkbG5q3jtyxPmDQ=";
  };

  npmDepsHash = "sha256-+JXM5vWaobLNZf/MJCsPcR0xmCGfPdJ56HH0Qan+KEQ=";

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
