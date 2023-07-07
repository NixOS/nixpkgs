{ lib
, python3
, fetchFromGitHub
, fetchpatch
, wrapQtAppsHook
}:

python3.pkgs.buildPythonApplication rec {
  pname = "sasview";
  version = "5.0.4";

  src = fetchFromGitHub {
    owner = "SasView";
    repo = "sasview";
    rev = "v${version}";
    hash = "sha256-TjcchqA6GCvkr59ZgDuGglan2RxLp+aMjJk28XhvoiY=";
  };

  patches = [
    # Fix `asscalar` numpy API removal.
    # See https://github.com/SasView/sasview/pull/2178
    (fetchpatch {
      url = "https://github.com/SasView/sasview/commit/b1ab08c2a4e8fdade7f3e4cfecf3dfec38b8f3c5.patch";
      hash = "sha256-IH8g4XPziVAnkmBdzLH1ii8vN6kyCmOgrQlH2HEbm5o=";
    })
  ];

  # AttributeError: module 'numpy' has no attribute 'float'.
  postPatch = ''
    substituteInPlace src/sas/sascalc/pr/p_invertor.py \
      --replace "dtype=np.float)" "dtype=float)"
  '';

  nativeBuildInputs = [
    python3.pkgs.pyqt5
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

  pytestFlagsArray = [ "test" ];

  meta = with lib; {
    homepage = "https://www.sasview.org";
    description = "Fitting and data analysis for small angle scattering data";
    maintainers = with maintainers; [ rprospero ];
    license = licenses.bsd3;
  };
}
