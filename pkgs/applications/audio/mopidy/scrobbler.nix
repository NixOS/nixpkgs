{
  lib,
  pythonPackages,
  fetchPypi,
  mopidy,
}:

pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "mopidy-scrobbler";
  version = "3.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "mopidy_scrobbler";
    hash = "sha256-kYBah5eUZGwFTPlyN+ILjKcZVpW4e1+VFSu2OSlN9Sw=";
  };

  build-system = [
    pythonPackages.setuptools
    pythonPackages.setuptools-scm
  ];

  dependencies = [
    mopidy
    pythonPackages.pylast
  ];

  # no tests implemented
  doCheck = false;
  pythonImportsCheck = [ "mopidy_scrobbler" ];

  meta = {
    homepage = "https://github.com/mopidy/mopidy-scrobbler";
    description = "Mopidy extension for scrobbling played tracks to Last.fm";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jakeisnt ];
  };
})
