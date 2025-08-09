{
  lib,
  qt5,
  python3,
  fetchFromGitHub,
  ffmpeg,
  libnotify,
  pulseaudio,
  sound-theme-freedesktop,
  pkg-config,
  meson,
  ninja,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "persepolis";
  version = "5.1.1";
  format = "other";

  src = fetchFromGitHub {
    owner = "persepolisdm";
    repo = "persepolis";
    tag = version;
    hash = "sha256-+gdrcEOUrMZw4nTO4bFLGanD4f7OumxTE99hpXlo69w=";
  };

  postPatch = ''
    # Ensure dependencies with hard-coded FHS dependencies are properly detected
    substituteInPlace check_dependencies.py --replace-fail "isdir(notifications_path)" "isdir('${sound-theme-freedesktop}/share/sounds/freedesktop')"
  '';

  # prevent double wrapping
  dontWrapQtApps = true;
  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    qt5.wrapQtAppsHook
  ];

  # feed args to wrapPythonApp
  makeWrapperArgs = [
    "--prefix PATH : ${
      lib.makeBinPath [
        ffmpeg
        libnotify
      ]
    }"
    "\${qtWrapperArgs[@]}"
  ];

  propagatedBuildInputs = [
    pulseaudio
    sound-theme-freedesktop
  ]
  ++ (with python3.pkgs; [
    psutil
    pyqt5
    requests
    setproctitle
    setuptools
    yt-dlp
  ]);

  meta = with lib; {
    description = "Download manager GUI written in Python";
    mainProgram = "persepolis";
    homepage = "https://persepolisdm.github.io/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ iFreilicht ];
  };
}
