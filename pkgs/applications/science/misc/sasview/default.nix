{
  lib,
<<<<<<< HEAD
  stdenv,
  python3,
  fetchFromGitHub,
  writeShellScriptBin,
  qt6,
  writableTmpDirAsHomeHook,
  ausaxs,
}:

let
  version = "6.1.1";

  pyside-tools-uic = writeShellScriptBin "pyside6-uic" ''
    exec ${qt6.qtbase}/libexec/uic -g python "$@"
  '';

  pyside-tools-rcc = writeShellScriptBin "pyside6-rcc" ''
    exec ${qt6.qtbase}/libexec/rcc -g python "$@"
  '';
in
python3.pkgs.buildPythonApplication {
  pname = "sasview";
  inherit version;
=======
  python3,
  fetchFromGitHub,
  wrapQtAppsHook,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sasview";
  version = "5.0.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SasView";
    repo = "sasview";
<<<<<<< HEAD
    tag = "v${version}";
    hash = "sha256-dc1vr+YFHItCI4NnSa+yF948/t7B6utoSp2ps/J40ys=";
  };

  build-system = with python3.pkgs; [
    hatchling
    hatch-build-scripts
    hatch-requirements-txt
    hatch-sphinx
    hatch-vcs
  ];

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    pyside-tools-rcc
    pyside-tools-uic
    python3.pkgs.pyside6
    python3.pkgs.sasdata
    python3.pkgs.sasmodels
  ];

  buildInputs = [ qt6.qtbase ];

  dependencies = with python3.pkgs; [
    sasmodels
    siphash24
    bumps
    columnize
    tccbox
    hatch-sphinx
    sasdata
    matplotlib
    appdirs
    dominate
    html2text
    html5lib
    ipython
    jsonschema
    mako
    numba
    periodictable
    platformdirs
    pybind11
    pylint
    pyopencl
    pyopengl
    pyside6
    pytools
    qtconsole
    superqt
    twisted
    uncertainties
    xhtml2pdf
    zope-interface
  ];

  pythonRemoveDeps = [ "zope" ];

=======
    rev = "refs/tags/v${version}";
    hash = "sha256-cwP9VuvO4GPlbAxCqw31xISTi9NoF5RoBQmjWusrnzc=";
  };

  # AttributeError: module 'numpy' has no attribute 'float'.
  postPatch = ''
    substituteInPlace src/sas/sascalc/pr/p_invertor.py \
      --replace "dtype=np.float)" "dtype=float)"
  '';

  nativeBuildInputs = [
    python3.pkgs.pyqt5
    python3.pkgs.setuptools
    wrapQtAppsHook
  ];

  propagatedBuildInputs = with python3.pkgs; [
    bumps
    h5py
    lxml
    periodictable
    pillow
    pyparsing
    pyqt5
    qt5reactor
    sasmodels
    scipy
    setuptools
    xhtml2pdf
  ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  postBuild = ''
    ${python3.interpreter} src/sas/qtgui/convertUI.py
  '';

  dontWrapQtApps = true;

  makeWrapperArgs = [
    "\${qtWrapperArgs[@]}"
  ];

<<<<<<< HEAD
  nativeCheckInputs =
    with python3.pkgs;
    [
      pytestCheckHook
      unittest-xml-reporting
    ]
    ++ [
      writableTmpDirAsHomeHook
      ausaxs
    ];
=======
  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    unittest-xml-reporting
  ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  enabledTestPaths = [
    "test"
  ];

<<<<<<< HEAD
  disabledTestPaths = [ "test/sascalculator/utest_sas_gen.py::sas_gen_test::test_debye_impl" ];

  preCheck =
    let
      ext = stdenv.hostPlatform.extensions.sharedLibrary;
    in
    ''
      ln -s ${ausaxs}/lib/libausaxs.${ext} src/sas/sascalc/calculator/ausaxs/lib/libausaxs.${ext}
    '';
=======
  disabledTests = [
    # NoKnownLoaderException
    "test_invalid_cansas"
    "test_data_reader_exception"
  ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  meta = {
    description = "Fitting and data analysis for small angle scattering data";
    homepage = "https://www.sasview.org";
    changelog = "https://github.com/SasView/sasview/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ rprospero ];
  };
}
