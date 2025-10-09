{
  lib,
  qt6,
  python3,
  fetchFromGitHub,
  ffmpeg,
  pkg-config,
  meson,
  ninja,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "persepolis";
  version = "5.2.0";
  format = "other";

  src = fetchFromGitHub {
    owner = "persepolisdm";
    repo = "persepolis";
    tag = version;
    hash = "sha256-E295Y76EmG6H1nwu7d4+OVPRtoCthROqYY5sIsBvUPI=";
  };

  # prevent double wrapping
  dontWrapQtApps = true;
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    qt6.wrapQtAppsHook
    qt6.qtbase
  ];

  # feed args to wrapPythonApp
  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        ffmpeg
      ]
    }"
    "\${qtWrapperArgs[@]}"
  ];

  propagatedBuildInputs = [
    (with python3.pkgs; [
      psutil
      pyside6
      pysocks
      urllib3
      dasbus
      requests
      setproctitle
      setuptools
      yt-dlp
    ])
  ];

  meta = with lib; {
    description = "Download manager GUI written in Python";
    mainProgram = "persepolis";
    homepage = "https://persepolisdm.github.io/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [
      iFreilicht
      L0L1P0P
    ];
  };
}
