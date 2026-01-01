{
  lib,
<<<<<<< HEAD
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
=======
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication {
  pname = "regippy";
  version = "2.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "airbus-cert";
    repo = "regrippy";
    rev = "05c9db999853c47af1d15f92f1a34aa2441e8882";
    hash = "sha256-gS7qVPlXwn6UXRXPN5ahPmQL3JpwmESUEi0KKAzOo+8=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  postInstall = ''
    mv $out/bin/regrip.py $out/bin/regrippy
  '';

<<<<<<< HEAD
  build-system = [ python3Packages.setuptools ];

  dependencies = with python3Packages; [
    importlib-resources
    python-registry
=======
  build-system = [ python3.pkgs.setuptools ];

  dependencies = [
    python3.pkgs.importlib-resources
    python3.pkgs.python-registry
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  ];

  meta = {
    description = "Modern Python-3-based alternative to RegRipper";
    homepage = "https://github.com/airbus-cert/regrippy";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ mikehorn ];
    mainProgram = "regrippy";
  };
}
