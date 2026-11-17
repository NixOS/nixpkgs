{
  lib,
  fetchPypi,
  python3Packages,
}:
let
  # build zala, a screenshot tool (lancit dependency)
  # this takes a screenshot to send to lancet for ocr
  # processing. this is not a screenshot utility tool
  zala = python3Packages.buildPythonPackage rec {
    pname = "zala";
    version = "26.4.26.0";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-ZLwHyI6nmiI9lxVWVZ3crLeZfmdhoWZaZ3ZgUNXJG/s=";
    };

    build-system = with python3Packages; [
      hatchling
      hatch-vcs
    ];

    dependencies = with python3Packages; [
      beartype
      pyqt6
      fire
      loguru
    ];
  };

  # build transformers 5.23.0, for language model-definition framework (lancit dependency)
  # was pinned to transformers 5.18.0 because later releases created errors.
  # bumped version to 5.23.0 since those errors were resolved with this ver.
  # pinned to 5.23.0 to avoid breakage with future updates
  transformers-5-23 = python3Packages.buildPythonPackage rec {
    pname = "transformers";
    version = "5.23.0";
    pyproject = true;

    src = fetchPypi {
      inherit pname version;
      hash = "sha256-GdZHpNXZA6fGRMpc3i2G78Pd59jGh655iIBv8iBe+nE=";
    };

    build-system = [ python3Packages.setuptools ];

    dependencies = with python3Packages; [
      huggingface-hub
      numpy
      packaging
      pyyaml
      regex
      safetensors
      tokenizers
      tqdm
      typer
    ];
  };
in
python3Packages.buildPythonApplication rec {
  pname = "ajt_lancet";
  version = "26.11.17.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-2Kk68mjYz5BH8zG3cqhCGyBUYE9mUXiF7RBJYkd979Y=";
  };

  build-system = with python3Packages; [
    hatchling
    hatch-vcs
  ];

  dependencies = with python3Packages; [
    zala
    transformers-5-23
    beartype
    pyqt6
    pillow
    pynput
    fire
    jaconv
    loguru
    numpy
    torch
    opencv-python-headless
    torchvision
    pyclipper
    shapely
    requests
    fugashi
    unidic-lite
  ];

  meta = {
    description = "OCR application for reading manga in Japanese, made for AJATTers";
    longDescription = "Lancet is an OCR application for reading manga in Japanese. It uses PyTorch models to recognize Japanese text in images. Lancet works best with Goldendict-ng or Rikaitan.";
    homepage = "https://github.com/Ajatt-Tools/lancet";
    license = lib.licenses.agpl3Plus;
    maintainers = with lib.maintainers; [ jt1tor ];
    mainProgram = "lancet";
  };
}
