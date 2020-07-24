{ buildPythonApplication, fetchFromGitHub, lib, paramiko, peewee, pyqt5
, python-dateutil, APScheduler, psutil, qdarkstyle, secretstorage
, appdirs, setuptools, qt5
}:

buildPythonApplication rec {
  pname = "vorta";
  version = "0.6.26";

  src = fetchFromGitHub {
    owner = "borgbase";
    repo = "vorta";
    rev = "v${version}";
    sha256 = "189kzwdmissg9142cd7wvxa1rvc2y7lysgr7if99zc7ks59mv6dq";
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

  postFixup = ''
    wrapQtApp $out/bin/vorta
  '';

  meta = with lib; {
    license = licenses.gpl3;
    homepage = "https://vorta.borgbase.com/";
    maintainers = with maintainers; [ ma27 ];
    description = "Desktop Backup Client for Borg";
    platforms = platforms.linux;
  };
}
