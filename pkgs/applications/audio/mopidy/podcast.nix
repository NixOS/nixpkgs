{
  lib,
  pythonPackages,
  fetchPypi,
  mopidy,
}:

pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "mopidy-podcast";
  version = "4.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "mopidy_podcast";
    hash = "sha256-EnFMEhJeVjhrwOApgeU92WzYZGraBFTAntmUsc423+o=";
  };

  build-system = [
    pythonPackages.setuptools
    pythonPackages.setuptools-scm
  ];

  dependencies = [
    mopidy
    pythonPackages.cachetools
    pythonPackages.uritools
  ];

  nativeCheckInputs = [
    pythonPackages.pytestCheckHook
  ];

  pythonImportsCheck = [ "mopidy_podcast" ];

  meta = {
    homepage = "https://github.com/tkem/mopidy-podcast";
    description = "Mopidy extension for browsing and playing podcasts";
    license = lib.licenses.asl20;
    maintainers = [
      lib.maintainers.daneads
    ];
  };
})
