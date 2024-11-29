{
  lib,
  buildPythonPackage,
  fetchPypi,
  blessed,
  docopt,
  pillow,
  requests,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pixcat";
  version = "0.1.4";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    sha256 = "657c8fe04513caecccd6086b347aa4b85db6b4c0f761b162cb9cd789abe7abb6";
  };

  propagatedBuildInputs = [
    blessed
    docopt
    pillow
    requests
  ];

  pythonImportsCheck = [ "pixcat" ];

  meta = with lib; {
    description = "Display images on a kitty terminal with optional resizing";
    mainProgram = "pixcat";
    homepage = "https://github.com/mirukan/pixcat";
    license = licenses.lgpl3;
    maintainers = [ maintainers.tilcreator ];
  };
}
