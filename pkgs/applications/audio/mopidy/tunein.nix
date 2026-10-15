{
  lib,
  pythonPackages,
  fetchPypi,
  mopidy,
}:

pythonPackages.buildPythonApplication (finalAttrs: {
  pname = "mopidy-tunein";
  version = "1.1.0";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) version;
    pname = "Mopidy-TuneIn";
    hash = "sha256-kQqWVS0jm/rubvNjXPkBj373M6wxHNCxHyczTb1WwQc=";
  };

  build-system = [
    pythonPackages.setuptools
  ];

  dependencies = [
    mopidy
  ];

  pythonImportsCheck = [ "mopidy_tunein.tunein" ];

  meta = {
    description = "Mopidy extension for playing music from tunein";
    homepage = "https://github.com/kingosticks/mopidy-tunein";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
})
