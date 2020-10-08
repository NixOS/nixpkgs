{ buildPythonApplication, fetchFromGitHub, lib, paramiko, peewee, pyqt5
, python-dateutil, APScheduler, psutil, qdarkstyle, secretstorage
, appdirs, setuptools, qt5
}:

buildPythonApplication rec {
  pname = "vorta";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "borgbase";
    repo = "vorta";
    rev = "v${version}";
    sha256 = "069fq5gv324l2ap3g6m6i12lhq1iqm27dsmaagyc3sva945j0gxw";
  };

  postPatch = ''
    sed -i -e '/setuptools_git/d' -e '/pytest-runner/d' setup.cfg
  '';

  nativeBuildInputs = [ qt5.wrapQtAppsHook ];

  propagatedBuildInputs = [
    paramiko peewee pyqt5 python-dateutil APScheduler psutil qdarkstyle
    secretstorage appdirs setuptools
  ];

  # QT setup in tests broken.
  doCheck = false;

  preFixup = ''
    makeWrapperArgs+=("''${qtWrapperArgs[@]}")
  '';

  meta = with lib; {
    license = licenses.gpl3;
    homepage = "https://vorta.borgbase.com/";
    maintainers = with maintainers; [ ma27 ];
    description = "Desktop Backup Client for Borg";
    platforms = platforms.linux;
  };
}
