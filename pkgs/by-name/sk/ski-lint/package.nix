{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "ski-lint";
  version = "0.3.2";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "svdimchenko";
    repo = "ski-lint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D2jFGpHOP4RvaDE72Dj3aGFppILCqMA/FUeFi93TEAc=";
  };

  build-system = [ python3Packages.poetry-core ];

  dependencies = with python3Packages; [
    chardet
    omegaconf
  ];

  pythonImportsCheck = [ "ski_lint" ];

  meta = {
    description = "A pre-commit hook, that enforces ASCII content.";
    mainProgram = "ski-lint";
    homepage = "https://github.com/svdimchenko/ski-lint";
    license = lib.licenses.mit;
    maintainers = [
      lib.maintainers.MartenBE
    ];
  };
})
