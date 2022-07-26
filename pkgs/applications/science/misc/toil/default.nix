{ lib
, fetchFromGitHub
, python3
}:

python3.pkgs.buildPythonApplication rec {
  pname = "toil";
  version = "5.6.0";
  format = "setuptools";

  src = python3.pkgs.fetchPypi {
    inherit pname version;
    sha256 = "sha256-m6tzrRCCLULO+wB8htUlt0KESLm/vdIeTzBrihnAo/I=";
  };

  propagatedBuildInputs = with python3.pkgs; [
    addict
    docker
    pytz
    pyyaml
    enlighten
    psutil
    py-tes
    python-dateutil
    dill
  ];

  checkInputs = with python3.pkgs; [
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "src/toil/test"
  ];

  pythonImportsCheck = [
    "toil"
  ];

  meta = with lib; {
    description = "Workflow engine written in pure Python";
    homepage = "https://toil.ucsc-cgl.org/";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ veprbl ];
  };
}
