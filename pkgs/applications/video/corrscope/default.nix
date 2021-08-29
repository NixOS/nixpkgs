{ lib
, mkDerivationWith
, python3Packages
, wrapQtAppsHook
, ffmpeg
, qtbase
}:

mkDerivationWith python3Packages.buildPythonApplication rec {
  pname = "corrscope";
  version = "0.7.0";

  src = python3Packages.fetchPypi {
    inherit pname version;
    sha256 = "0m62p3jlbx5dlp3j8wn1ka1sqpffsxbpsgv2h5cvj1n1lsgbss2s";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'attrs>=18.2.0,<19.0.0' 'attrs>=18.2.0' \
      --replace 'numpy>=1.15,<2.0,!=1.19.4' 'numpy>=1.15,<2.0'
  '';

  nativeBuildInputs = [ wrapQtAppsHook ];

  buildInputs = [ ffmpeg qtbase ];

  propagatedBuildInputs = with python3Packages; [ appdirs attrs click matplotlib numpy pyqt5 ruamel_yaml ];

  dontWrapQtApps = true;

  preFixup = ''
    makeWrapperArgs+=(
      --prefix PATH : ${ffmpeg}/bin
      "''${qtWrapperArgs[@]}"
    )
  '';

  preCheck = "export HOME=$TEMP";

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
