{ lib
, fetchFromGitHub
, gitUpdater
, substituteAll
, ffmpeg
, python3Packages
, sox
}:

python3Packages.buildPythonApplication rec {
  pname = "r128gain";
  version = "1.0.7";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = "r128gain";
    rev = version;
    sha256 = "sha256-JyKacDqjIKTNl2GjbJPkgbakF8HR4Jd4czAtOaemDH8=";
  };

  patches = [
    (substituteAll {
      src = ./ffmpeg-location.patch;
      inherit ffmpeg;
    })
  ];

  propagatedBuildInputs = with python3Packages; [ crcmod ffmpeg-python mutagen tqdm ];
  nativeCheckInputs = with python3Packages; [ requests sox ];

  # Testing downloads media files for testing, which requires the
  # sandbox to be disabled.
  doCheck = false;

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Fast audio loudness scanner & tagger (ReplayGain v2 / R128)";
    mainProgram = "r128gain";
    homepage = "https://github.com/desbma/r128gain";
    license = licenses.lgpl2Plus;
    maintainers = [ ];
    platforms = platforms.all;
  };
}
