{
  lib,
  python3Packages,
  fetchPypi,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "alerta";
  version = "8.5.3";
  pyproject = true;

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ePvT2icsgv+io5aDDUr1Zhfodm4wlqh/iqXtNkFhS10=";
  };

  build-system = with python3Packages; [ setuptools ];

  dependencies = with python3Packages; [
    click
    requests
    requests-hawk
    pytz
    tabulate
  ];

  doCheck = true;

  pythonImportsCheck = [ "alertaclient" ];

  nativeCheckInputs = with python3Packages; [
    pytestCheckHook
    requests-mock
  ];

  # AlertTestCases attempt to connect to alerta api
  disabledTests = [ "AlertTestCase" ];

  meta = {
    homepage = "https://alerta.io";
    description = "Alerta Monitoring System command-line interface";
    mainProgram = "alerta";
    license = lib.licenses.asl20;
  };
})
