{
  lib,
  pythonPackages,
  fetchPypi,
  mopidy,
  glibcLocales,
}:

pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "mopidy-moped";
  version = "0.7.1";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "Mopidy-Moped";
    hash = "sha256-FUYRdAN9h6+T3VmiNtQnXFq/cc6gZw//8kp9A5moouQ=";
  };

  env.LC_ALL = "en_US.UTF-8";
  buildInputs = [ glibcLocales ];

  build-system = [ pythonPackages.setuptools ];

  dependencies = [ mopidy ];

  # no tests implemented
  doCheck = false;

  pythonImportsCheck = [ "mopidy_moped" ];

  meta = {
    homepage = "https://github.com/martijnboland/moped";
    description = "Web client for Mopidy";
    license = lib.licenses.mit;
    maintainers = [ ];
    hydraPlatforms = [ ];
  };
})
