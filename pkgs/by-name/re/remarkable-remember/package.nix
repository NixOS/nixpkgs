{
  fetchFromGitHub,
  buildDotnetModule,
  lib,
}:

buildDotnetModule (finalAttrs: {
  pname = "remarkable-remember";
  version = "1.8.2";

  src = fetchFromGitHub {
    owner = "ds160";
    repo = "remarkable-remember";
    tag = finalAttrs.version;
    hash = "sha256-9LEMMJm9SgXUU13Q7+BLJ5lM6QCebwFrOKCgczoFkZQ=";
  };

  projectFile = "src/ReMarkableRemember/ReMarkableRemember.csproj";

  nugetDeps = ./deps.json;

  meta = {
    homepage = "https://github.com/ds160/remarkable-remember";
    description = "A cross-platform management application for your reMarkable tablet.";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      MeRayORG
    ];
  };
})
