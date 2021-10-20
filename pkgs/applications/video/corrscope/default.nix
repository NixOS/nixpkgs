{ lib
, mkDerivationWith
, python3Packages
, fetchFromGitHub
, fetchpatch
, wrapQtAppsHook
, ffmpeg
, qtbase
}:

mkDerivationWith python3Packages.buildPythonApplication rec {
  pname = "corrscope";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "corrscope";
    repo = "corrscope";
    rev = version;
    sha256 = "0c9kmrw6pcda68li04b5j2kmsgdw1q463qlc32wn96zn9hl82v6m";
  };

  format = "pyproject";

  patches = [
    # Remove when bumping past 0.7.1
    (fetchpatch {
      name = "0001-Use-poetry-core.patch";
      url = "https://github.com/corrscope/corrscope/commit/d40d1846dd54b8bccd7b8055d6aece48aacbb943.patch";
      sha256 = "0xxsbmxdbh3agfm6ww3rpa7ab0ysppan490w0gaqwmwzrxmmdljv";
    })
  ];

  nativeBuildInputs = [ wrapQtAppsHook ] ++ (with python3Packages; [ poetry-core ]);

  buildInputs = [ ffmpeg qtbase ];

  propagatedBuildInputs = with python3Packages; [ appdirs atomicwrites attrs click matplotlib numpy pyqt5 ruamel_yaml ];

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
