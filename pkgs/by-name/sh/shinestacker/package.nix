{
  lib,
  python3,
  fetchFromGitHub,
}:

python3.pkgs.buildPythonApplication (finalAttrs: {
  pname = "shinestacker";
  version = "1.14.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "lucalista";
    repo = "shinestacker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GDX2Aotw5PmpZylACEA0PTjTNY/Hv1W+l4v6wMTe6hE=";
  };

  build-system = [
    python3.pkgs.setuptools
    python3.pkgs.setuptools-scm
  ];

  dependencies = with python3.pkgs; [
    imagecodecs
    ipywidgets
    jsonpickle
    matplotlib
    numpy
    opencv-python-headless
    pillow
    psdtags
    psutil
    pyside6
    rawpy
    scipy
    tifffile
    tqdm
  ];

  optional-dependencies = with python3.pkgs; {
    dev = [
      pytest
    ];
  };

  pythonImportsCheck = [
    "shinestacker"
  ];

  meta = {
    description = "Focus stacking code";
    homepage = "https://github.com/lucalista/shinestacker";
    changelog = "https://github.com/lucalista/shinestacker/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ paperdigits ];
    mainProgram = "shinestacker";
  };
})
