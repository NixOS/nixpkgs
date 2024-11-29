{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytestCheckHook,
  hypothesis,
}:

buildPythonPackage rec {
  pname = "hs-dbus-signature";
  version = "0.7";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-NNnTcSX+K8zU+sj1QBd13h7aEXN9VqltJMNWCuhgZ6I=";
  };

  nativeCheckInputs = [
    pytestCheckHook
    hypothesis
  ];

  pythonImportsCheck = [ "hs_dbus_signature" ];

  meta = with lib; {
    description = "Hypothesis Strategy for Generating Arbitrary DBus Signatures";
    homepage = "https://github.com/stratis-storage/hs-dbus-signature";
    license = licenses.mpl20;
    maintainers = with maintainers; [ nickcao ];
  };
}
