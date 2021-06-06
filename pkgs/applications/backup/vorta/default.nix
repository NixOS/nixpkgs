{ lib
, python3
, fetchFromGitHub
, wrapQtAppsHook
, borgbackup
}:

python3.pkgs.buildPythonApplication rec {
  pname = "vorta";
  version = "0.7.5";

  src = fetchFromGitHub {
    owner = "borgbase";
    repo = "vorta";
    rev = "v${version}";
    sha256 = "sha256-qPO8qmXYDDFwV+8hAUyfF4Ins0vkwEJbw4JPguUSYOw=";
  };

  postPatch = ''
    sed -i -e '/setuptools_git/d' -e '/pytest-runner/d' setup.cfg
  '';

  nativeBuildInputs = [ wrapQtAppsHook ];

  propagatedBuildInputs = with python3.pkgs; [
    paramiko peewee pyqt5 python-dateutil APScheduler psutil qdarkstyle
    secretstorage appdirs setuptools
  ];

  # QT setup in tests broken.
  doCheck = false;

  preFixup = ''
    makeWrapperArgs+=(
      "''${qtWrapperArgs[@]}"
      --prefix PATH : ${lib.makeBinPath [ borgbackup ]}
    )
  '';

  meta = with lib; {
    license = licenses.gpl3Only;
    homepage = "https://vorta.borgbase.com/";
    maintainers = with maintainers; [ ma27 ];
    description = "Desktop Backup Client for Borg";
    platforms = platforms.linux;
  };
}
