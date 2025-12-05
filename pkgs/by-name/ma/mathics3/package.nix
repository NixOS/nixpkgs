{
  lib,
  python3Packages,
  fetchPypi,
  fetchpatch2,
  versionCheckHook,
}:

python3Packages.buildPythonApplication rec {
  pname = "mathics3";
  version = "9.0.0";
  pyproject = true;

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-i0nBVrAS3YrJ67CJYyCKfeNlHNHrBI7GCk4fm+WG5wM=";
  };

  build-system = with python3Packages; [
    cython
    mathics-scanner
    packaging
    setuptools
  ];

  dependencies = with python3Packages; [
    mathics-scanner
    mpmath
    numpy
    palettable
    pillow
    pint
    pympler
    python-dateutil
    requests
    scipy
    setuptools
    stopit
    sympy
  ];

  optional-dependencies = with python3Packages; {
    cython = [ cython ];

    dev = [
      pexpect
      pytest
    ];

    full = [
      ipywidgets
      llvmlite
      lxml
      psutil
      pyocr
      scikit-image
      unidecode
      wordcloud
    ];
  };

  pythonImportsCheck = [ "mathics" ];

  patches = [
    # Remove mathics3 > 9.0.0
    (fetchpatch2 {
      url = "https://github.com/Mathics3/mathics-core/commit/dce5300c96beb97f72c41f4171af19788781a5cb.patch";
      hash = "sha256-OTgYLZ7je1w91rjE9MAEI3S3z3CgaLFELFts8SNn2/w=";
    })
  ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "--version";

  meta = {
    description = "General-purpose computer algebra system (CAS)";
    longDescription = ''
      Mathics3 is a free general-purpose computer algebra system
      featuring Mathematica®-compatible syntax and functions.
    '';
    homepage = "https://mathics.org";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ yiyu ];
    mainProgram = "mathics";
  };
}
