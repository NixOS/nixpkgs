{
  lib,
  python3Packages,
  fetchPypi,
}:

let
  pname = "regrippy";
  version = "2.0.2";
in
python3Packages.buildPythonApplication {
  inherit pname version;
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-43Wh5iQE1ihD8aGxDmmwKDkPeMfySP0mdk0XhrVefyc=";
  };

  postInstall = ''
    mv $out/bin/regrip.py $out/bin/regrippy
  '';

  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    importlib-resources
    python-registry
  ];

  meta = {
    description = "Modern Python-3-based alternative to RegRipper";
    homepage = "https://github.com/airbus-cert/regrippy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mikehorn ];
    mainProgram = "regrippy";
  };
}
