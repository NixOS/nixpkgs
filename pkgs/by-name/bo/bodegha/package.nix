{
  lib,
  python3Packages,
  fetchFromGitHub,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "bodegha";
  version = "1.0.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "sgl-umons";
    repo = "BoDeGHa";
    tag = "v${finalAttrs.version}";
    hash = "sha256-iqVblTfnOa5CouRgjALK/MLFMRnOeS2rSWd+Mjz/qX8=";
  };

  postPatch = ''
    # Remove an unneeded dependency
    # argparse is a Python standard module (Python > 3.2).
    substituteInPlace setup.py \
      --replace-fail "'argparse >= 1.1'," ""
    substituteInPlace setup.py \
      --replace-fail "python-levenshtein" "levenshtein"
  '';

  build-system = [
    python3Packages.setuptools
  ];

  pythonRelaxDeps = [ "scikit-learn" ];

  dependencies = with python3Packages; [
    numpy
    pandas
    python-dateutil
    levenshtein
    scikit-learn
    setuptools
    tqdm
    urllib3
  ];

  pythonImportsCheck = [
    "bodegha"
  ];

  meta = {
    description = "A python tool to predict the identity type in github activities (Human,Bot)";
    homepage = "https://github.com/sgl-umons/BoDeGHa";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ drupol ];
    mainProgram = "bodegha";
  };
})
