{
  lib,
  qt5,
  python3,
  fetchFromGitHub,
  aria2,
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
  version = "4.0.1";
  format = "other";

  src = fetchFromGitHub {
    owner = "persepolisdm";
    repo = "persepolis";
    rev = "57dc9d438bb3f126070a17c7a3677c45ea4dd332";
    hash = "sha256-7OXAITFQJ2/aY0QmqlAo7if7cY7+T3j6PUjfJJV8Z2Q=";
  };

  patches = [
    # Upstream does currently not allow building from source on macOS. These patches can likely
    # be removed if https://github.com/persepolisdm/persepolis/issues/943 is fixed upstream
    ./0003-Search-PATH-for-aria2c-on-darwin.patch
    ./0004-Search-PATH-for-ffmpeg-on-darwin.patch
  ];

  postPatch = ''
    # Ensure dependencies with hard-coded FHS dependencies are properly detected
    substituteInPlace check_dependencies.py --replace-fail "isdir(notifications_path)" "isdir('${sound-theme-freedesktop}/share/sounds/freedesktop')"
  '';

  postInstall = ''
    mkdir -p $out/share/applications
    cp $src/xdg/com.github.persepolisdm.persepolis.desktop $out/share/applications
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
        aria2
        ffmpeg
        libnotify
      ]
    }"
    "\${qtWrapperArgs[@]}"
  ];

  # The presence of these dependencies is checked during setuptoolsCheckPhase,
  # but apart from that, they're not required during build, only runtime
  nativeCheckInputs = [
    aria2
    libnotify
    pulseaudio
    sound-theme-freedesktop
    ffmpeg
  ];

  propagatedBuildInputs =
    [
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
    description = "GUI for aria2";
    mainProgram = "persepolis";
    homepage = "https://persepolisdm.github.io/";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ iFreilicht ];
  };
}
