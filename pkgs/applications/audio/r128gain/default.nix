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
  version = "1.0.3";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = "r128gain";
    rev = version;
    sha256 = "0w2i2szajv1vcmc96w0fczdr8xc28ijcf1gdg180f21gi6yh96sc";
  };

  patches = [
    (substituteAll {
      src = ./ffmpeg-location.patch;
      inherit ffmpeg;
    })
  ];

  propagatedBuildInputs = with python3Packages; [ crcmod ffmpeg-python mutagen tqdm ];
  checkInputs = with python3Packages; [ requests sox ];

  # Testing downloads media files for testing, which requires the
  # sandbox to be disabled.
  doCheck = false;

  passthru.updateScript = gitUpdater { inherit pname version; };

  meta = with lib; {
    description = "Fast audio loudness scanner & tagger (ReplayGain v2 / R128)";
    homepage = "https://github.com/desbma/r128gain";
    license = licenses.lgpl2Plus;
    maintainers = [ maintainers.AluisioASG ];
    platforms = platforms.all;
  };
}
