{
  lib,
  python3Packages,
  fetchFromGitHub,
}:
python3Packages.buildPythonApplication (finalAttrs: {
  pname = "dpt-rp1-py";
  version = "0.1.19";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "janten";
    repo = "dpt-rp1-py";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-cJ9dc8TRuduIka6T/MQsetDAjIhb+i2U9F8Qm9h29d8=";
  };

  doCheck = false;

  build-system = with python3Packages; [
    setuptools
  ];

  dependencies = with python3Packages; [
    anytree
    fusepy
    httpsig
    pbkdf2
    pyyaml
    requests
    tqdm
    urllib3
    zeroconf
  ];

  pythonImportsCheck = [ "dptrp1" ];

  meta = {
    homepage = "https://github.com/janten/dpt-rp1-py";
    description = "Python script to manage Sony DPT-RP1 without Digital Paper App";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ mt-caret ];
    mainProgram = "dptrp1";
  };
})
