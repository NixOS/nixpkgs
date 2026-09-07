{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry,
  poetry-core,
}:

buildPythonPackage (finalAttrs: {
  pname = "poeblix";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "spoorn";
    repo = "poeblix";
    tag = finalAttrs.version;
    hash = "sha256-TKadEOk9kM3ZYsQmE2ftzjHNGNKI17p0biMr+Nskigs=";
  };

  build-system = [
    poetry-core
  ];

  pythonRelaxDeps = [
    "poetry"
  ];

  buildInputs = [
    poetry
  ];

  doCheck = false;
  pythonImportsCheck = [ "poeblix" ];

  meta = {
    changelog = "https://github.com/spoorn/poeblix/releases/tag/${finalAttrs.src.tag}";
    description = "Poetry Plugin that adds various features that extend the poetry command such as building wheel files with locked dependencies, and validations of wheel/docker containers";
    license = lib.licenses.mit;
    homepage = "https://github.com/spoorn/poeblix";
    maintainers = with lib.maintainers; [ hennk ];
  };
})
