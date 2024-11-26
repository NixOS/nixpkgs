{
  lib,
  buildPythonPackage,
  fetchPypi,
}:

buildPythonPackage rec {
  pname = "gym-notices";
  version = "0.0.8";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-rSXiAEh8r6NpcoYl/gZOiK2hNGYYUmECZZtGQPK0uRE=";
  };

  pythonImportsCheck = [ "gym_notices" ];

  meta = with lib; {
    description = "Notices for Python package Gym";
    homepage = "https://github.com/Farama-Foundation/gym-notices";
    license = licenses.mit;
    maintainers = with maintainers; [ billhuang ];
  };
}
