{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  numpy,
  setuptools,
  versioneer,

  # dependencies
  joblib,
  pandas,
  rich,
  scipy,
  threadpoolctl,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "better-optimize";
  version = "0.5.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "jessegrabowski";
    repo = "better_optimize";
    tag = "v${finalAttrs.version}";
    # Let versioneer find the version (`_version.py` relies on `export-subst`)
    postFetch = ''
      sed -i 's/git_refnames = "[^"]*"/git_refnames = " (tag: ${finalAttrs.src.tag})"/' $out/better_optimize/_version.py
    '';
    hash = "sha256-k0OJ1UxAJaOYJMDCPNX3RpIvDLrMLndpj81HysensZs=";
  };

  build-system = [
    numpy
    setuptools
    versioneer
  ];

  dependencies = [
    joblib
    numpy
    pandas
    rich
    scipy
    threadpoolctl
  ];

  pythonImportsCheck = [ "better_optimize" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "Drop-in replacement for scipy optimize functions with quality of life improvements";
    homepage = "https://github.com/jessegrabowski/better_optimize";
    changelog = "https://github.com/jessegrabowski/better_optimize/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
