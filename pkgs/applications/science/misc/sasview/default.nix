{ lib
, python3
, fetchFromGitHub
, which
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

  checkInputs = with python3.pkgs; [
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
