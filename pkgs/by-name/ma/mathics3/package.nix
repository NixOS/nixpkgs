{
  lib,
  python3Packages,
  fetchFromGitHub,
  versionCheckHook,
  writableTmpDirAsHomeHook,
}:

python3Packages.buildPythonApplication (finalAttrs: {
  pname = "mathics3";
  version = "10.0.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "Mathics3";
    repo = "mathics-core";
    tag = finalAttrs.version;
    hash = "sha256-SRX4aDCGmFHi5wmzuQGWQtSzlcc0f1SVFg8UEIOp9PE=";
  };

  # Tagged sources carry a development version and lack the generated tables
  postPatch = ''
    substituteInPlace mathics/version.py \
      --replace-fail '"${finalAttrs.version}dev0"' '"${finalAttrs.version}"'
  '';

  preBuild = ''
    bash admin-tools/make-JSON-tables.sh
  '';

  build-system = with python3Packages; [
    cython
    mathics3-scanner
    packaging
    setuptools
  ];

  dependencies = with python3Packages; [
    mathics3-scanner
    mpmath
    numpy
    packaging
    palettable
    pillow
    pint
    pympler
    python-dateutil
    requests
    scipy
    setuptools
    timed-threads
    sympy
  ];

  optional-dependencies = with python3Packages; {
    cython = [ cython ];

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

  nativeCheckInputs = [
    writableTmpDirAsHomeHook
  ]
  ++ (with python3Packages; [
    pexpect
    pytestCheckHook
  ]);

  preCheck = ''
    # Upstream runs its test suite with ASCII output
    export MATHICS_CHARACTER_ENCODING=ASCII
    export PATH=$out/bin:$PATH
  '';

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
})
