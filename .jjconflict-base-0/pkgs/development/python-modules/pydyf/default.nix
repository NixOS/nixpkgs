{
  lib,
  buildPythonPackage,
  fetchPypi,
  flit-core,
  ghostscript,
  pillow,
  pytestCheckHook,
  pytest-cov-stub,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pydyf";
  version = "0.11.0";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-OU3d9hnMqdDFVxXjxV6hIam/nLx4DNwSAaJCeRe4a2Q=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "--isort --flake8" ""
  '';

  nativeBuildInputs = [ flit-core ];

  nativeCheckInputs = [
    ghostscript
    pillow
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "pydyf" ];

  meta = with lib; {
    description = "Low-level PDF generator written in Python and based on PDF specification 1.7";
    homepage = "https://doc.courtbouillon.org/pydyf/stable/";
    changelog = "https://github.com/CourtBouillon/pydyf/releases/tag/v${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ rprecenth ];
  };
}
