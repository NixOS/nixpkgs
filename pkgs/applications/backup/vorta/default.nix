{ buildPythonApplication, fetchFromGitHub, lib, paramiko, peewee, pyqt5
, python-dateutil, APScheduler, psutil, qdarkstyle, secretstorage
, appdirs, setuptools, qt5
}:

buildPythonApplication rec {
  pname = "vorta";
  version = "0.6.24";

  src = fetchFromGitHub {
    owner = "borgbase";
    repo = "vorta";
    rev = "v${version}";
    sha256 = "1xc4cng4npc7g739qd909a8wim6s6sn8h8bb1wpxzg4gcnfyin8z";
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
