{ lib
, mkDerivationWith
, python3Packages
, fetchFromGitHub
, wrapQtAppsHook
, ffmpeg
, qtbase
}:

mkDerivationWith python3Packages.buildPythonApplication rec {
  pname = "corrscope";
  version = "0.8.0";
  format = "pyproject";

  src = fetchFromGitHub {
    owner = "corrscope";
    repo = "corrscope";
    rev = version;
    sha256 = "1wdla4ryif1ss37aqi61lcvzddvf568wyh5s3xv1lrryh4al9vpd";
  };

  nativeBuildInputs = [
    wrapQtAppsHook
  ] ++ (with python3Packages; [
    poetry-core
  ]);

  buildInputs = [
    ffmpeg
    qtbase
  ];

  propagatedBuildInputs = with python3Packages; [
    appdirs
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
  };
}
