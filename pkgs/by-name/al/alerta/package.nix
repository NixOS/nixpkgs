{
  lib,
  python3,
  fetchPypi,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "alerta";
  version = "8.5.3";
  format = "setuptools";

  src = fetchPypi {
    inherit (finalAttrs) pname version;
    hash = "sha256-ePvT2icsgv+io5aDDUr1Zhfodm4wlqh/iqXtNkFhS10=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    six
    click
    requests
    requests-hawk
    pytz
    tabulate
  ];

  doCheck = false;

  meta = {
    homepage = "https://alerta.io";
    description = "Alerta Monitoring System command-line interface";
    mainProgram = "alerta";
    license = lib.licenses.asl20;
  };
})
