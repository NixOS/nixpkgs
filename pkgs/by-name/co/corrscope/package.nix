{
  stdenv,
  lib,
  fetchFromGitHub,
  ffmpeg,
  python3Packages,
  qt6Packages,
  testers,
  corrscope,
}:

python3Packages.buildPythonApplication rec {
  pname = "corrscope";
  version = "0.11.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "corrscope";
    repo = "corrscope";
    tag = version;
    hash = "sha256-76qa4jOSncK1eDly/uXJzpWWdsEz7Hg3DyFb7rmrQBc=";
  };

  nativeBuildInputs = with qt6Packages; [
    wrapQtAppsHook
  ];

  build-system = with python3Packages; [
    hatchling
  ];

  buildInputs = [
    ffmpeg
  ]
  ++ (
    with qt6Packages;
    [
      qtbase
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      qtwayland
    ]
  );

  dependencies = (
    with python3Packages;
    [
      appdirs
      atomicwrites
      attrs
      click
      colorspacious
      matplotlib
      numpy
      qtpy
      pyqt6
      ruamel-yaml
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      appnope
    ]
  );

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

  meta = {
    description = "Render wave files into oscilloscope views, featuring advanced correlation-based triggering algorithm";
    longDescription = ''
      Corrscope renders oscilloscope views of WAV files recorded from chiptune (game music from
      retro sound chips).

      Corrscope uses "waveform correlation" to track complex waves (including SNES and Sega
      Genesis/FM synthesis) which jump around on other oscilloscope programs.
    '';
    homepage = "https://github.com/corrscope/corrscope";
    changelog = "https://github.com/corrscope/corrscope/releases/tag/${version}";
    license = lib.licenses.bsd2;
    maintainers = with lib.maintainers; [ OPNA2608 ];
    platforms = lib.platforms.all;
    mainProgram = "corr";
  };
}
