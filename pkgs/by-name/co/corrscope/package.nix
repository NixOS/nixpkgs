{ stdenv
, lib
, python3Packages
, fetchFromGitHub
, ffmpeg
, libsForQt5
, testers
, corrscope
}:

python3Packages.buildPythonApplication rec {
  pname = "corrscope";
  version = "0.10.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "corrscope";
    repo = "corrscope";
    rev = "refs/tags/${version}";
    hash = "sha256-hyLCygaSWMQd+UJ/Ijgk9C+3O/r5x0aaW/x9PoojDIg=";
  };

  pythonRelaxDeps = [ "attrs" "ruamel.yaml" ];

  nativeBuildInputs = (with libsForQt5; [
    wrapQtAppsHook
  ]) ++ (with python3Packages; [
    poetry-core
  ]);

  buildInputs = [
    ffmpeg
  ] ++ (with libsForQt5; [
    qtbase
  ] ++ lib.optionals stdenv.hostPlatform.isLinux [
    qtwayland
  ]);

  propagatedBuildInputs = with python3Packages; [
    appdirs
    appnope
    atomicwrites
    attrs
    click
    matplotlib
    numpy
    packaging
    qtpy
    pyqt5
    ruamel-yaml
    colorspacious
  ];

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      --prefix PATH : ${lib.makeBinPath [ ffmpeg ]}
      "''${qtWrapperArgs[@]}"
    )
  '';

  passthru.tests.version = testers.testVersion {
    package = corrscope;
    # Tries writing to
    # - $HOME/.local/share/corrscope on Linux
    # - $HOME/Library/Application Support/corrscope on Darwin
    command = "env HOME=$TMPDIR ${lib.getExe corrscope} --version";
  };

  meta = with lib; {
    description = "Render wave files into oscilloscope views, featuring advanced correlation-based triggering algorithm";
    longDescription = ''
      Corrscope renders oscilloscope views of WAV files recorded from chiptune (game music from
      retro sound chips).

      Corrscope uses "waveform correlation" to track complex waves (including SNES and Sega
      Genesis/FM synthesis) which jump around on other oscilloscope programs.
    '';
    homepage = "https://github.com/corrscope/corrscope";
    license = licenses.bsd2;
    maintainers = with maintainers; [ OPNA2608 ];
    platforms = platforms.all;
    mainProgram = "corr";
  };
}
