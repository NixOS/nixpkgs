{
  lib,
  python3,
  fetchFromGitHub,
  wrapQtAppsHook,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sasview";
  version = "5.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "SasView";
    repo = "sasview";
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

  postBuild = ''
    ${python3.interpreter} src/sas/qtgui/convertUI.py
  '';

  dontWrapQtApps = true;

  makeWrapperArgs = [
    "\${qtWrapperArgs[@]}"
  ];

  nativeCheckInputs = with python3.pkgs; [
    pytestCheckHook
    unittest-xml-reporting
  ];

  enabledTestPaths = [
    "test"
  ];

  disabledTests = [
    # NoKnownLoaderException
    "test_invalid_cansas"
    "test_data_reader_exception"
  ];

  meta = {
    description = "Fitting and data analysis for small angle scattering data";
    homepage = "https://www.sasview.org";
    changelog = "https://github.com/SasView/sasview/releases/tag/v${version}";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ rprospero ];
  };
}
