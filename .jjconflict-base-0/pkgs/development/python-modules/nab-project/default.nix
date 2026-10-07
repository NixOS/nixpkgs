{
  buildPythonPackage,
  build,
  hatchling,
  installer,
  nab-index,
  nab-markersets,
  nab-provider,
  nab-resolver,
  nab,
  packaging,
  pyproject-hooks,
  tomli-w,
  tomli,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "nab-project";
  inherit (nab) src version;
  pyproject = true;

  sourceRoot = "${finalAttrs.src.name}/nab-project";

  build-system = [ hatchling ];

  dependencies = [
    build
    installer
    nab-index
    nab-markersets
    nab-provider
    nab-resolver
    packaging
    pyproject-hooks
    tomli
    tomli-w
    typing-extensions
  ];

  # The `nab` package runs this package's tests.
  doCheck = false;
  passthru.tests = { inherit nab; };

  pythonImportsCheck = [ "nab_project" ];

  meta = {
    description = "Resolve orchestration, lockfile generation, and downloads for nab";
    inherit (nab.meta)
      homepage
      changelog
      license
      maintainers
      ;
  };
})
