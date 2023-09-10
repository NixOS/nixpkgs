{ lib
, mkDerivationWith
, python3Packages
, fetchFromGitHub
, fetchpatch
, wrapQtAppsHook
, ffmpeg
, qtbase
, testers
, corrscope
}:

mkDerivationWith python3Packages.buildPythonApplication rec {
  pname = "corrscope";
  version = "0.8.1";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "corrscope";
    repo = "corrscope";
    rev = version;
    hash = "sha256-pS7upOYZAjgR3lWxny8TNZEj3Rrbg+L90ANZWFO9UPQ=";
  };

  patches = [
    # https://github.com/corrscope/corrscope/pull/446
    (fetchpatch {
      name = "remove-setuptools-dependency.patch";
      url = "https://github.com/corrscope/corrscope/commit/70b123173a7a012d9f29d6d3a8960b85caf6cc79.patch";
      hash = "sha256-YCtb7v8cGP0pdceAKeoempnRzw+LRKQqDb3AfN0z/9s=";
    })
  ];

  pythonRelaxDeps = [ "attrs" ];

  nativeBuildInputs = [
    wrapQtAppsHook
  ] ++ (with python3Packages; [
    poetry-core
    pythonRelaxDepsHook
  ]);

  buildInputs = [
    ffmpeg
    qtbase
  ];

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
