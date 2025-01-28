{
  lib,
  python3,
  fetchFromGitHub,
  fetchpatch,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "rabbit";
  version = "2.3.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "natarajan-chidambaram";
    repo = "RABBIT";
    tag = version;
    hash = "sha256-QmP6yfVnlYoNVa4EUtKR9xbCnQW2V6deV0+hN9IGtic=";
  };

  patches = [
    # scikit-learn 1.6.1 support
    (fetchpatch {
      url = "https://github.com/natarajan-chidambaram/RABBIT/commit/e1eb159c5beaef013a3e78e5570a0f7b16636ce6.patch";
      hash = "sha256-dxo7Ex7MIyyK9Agys+V/MLJgUvnbKBiVrhz1T+NRZ1Y=";
    })
  ];

  pythonRelaxDeps = [
    "numpy"
  ];

  build-system = with python3.pkgs; [
    setuptools
  ];

  dependencies = with python3.pkgs; [
    joblib
    numpy
    pandas
    python-dateutil
    requests
    scikit-learn
    scipy
    tqdm
    urllib3
  ];

  pythonImportsCheck = [ "rabbit" ];

  meta = {
    description = "Tool for identifying bot accounts based on their recent GitHub event history";
    homepage = "https://github.com/natarajan-chidambaram/RABBIT";
    license = lib.licenses.asl20;
    mainProgram = "rabbit";
    maintainers = with lib.maintainers; [ drupol ];
  };
}
