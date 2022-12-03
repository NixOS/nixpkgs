{ lib, buildPythonApplication, fetchPypi, fetchFromGitHub, python3Packages, qt5 }:
let
  pypdf2 = python3Packages.pypdf2.overrideAttrs (oldAttrs: rec {
    pname = "PyPDF2";
    version = "1.28.4";
    src = fetchPypi {
      inherit pname version;
      sha256 = "sha256-BM5CzQVweIH+28oxZHRFEYBf6MMGGK5M+yuUDjNo1a0=";
    };
    # Tests broken on Python 3.x
    unittestCheckPhase = "true";
    doCheck = false;
  });
in
buildPythonApplication rec {
  pname = "remy";
  version = "0.5";

  src = fetchFromGitHub {
    owner = "bordaigorl";
    repo = "remy";
    rev = "df2c1aec2efe8ba8f1f2ae098478eb8f580188dd";
    sha256 = "sha256-kbeNoQgEJetoStaVodmLVcWWDNj5g4k7r9PdhzAqVvQ=";
  };

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  propagatedBuildInputs = with python3Packages; [
    requests
    sip
    arrow
    paramiko
    pyqt5
    pypdf2
  ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "remy" ];

  preBuild = ''
      ${python3Packages.pyqt5}/bin/pyrcc5 -o remy/gui/resources.py resources.qrc
  '';

  postFixup = ''
    wrapQtApp $out/bin/remy
  '';

  meta = with lib; {
    description = "Remy, an online & offline manager for the reMarkable tablet";
    homepage = "https://github.com/bordaigorl/remy";
    license = licenses.gpl3;
    maintainers = [ maintainers.phaer ];
  };
}
