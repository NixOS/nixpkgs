{ lib
, fetchFromGitHub
, substituteAll
, ffmpeg
, python3Packages
, sox
}:

python3Packages.buildPythonApplication rec {
  pname = "r128gain";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "desbma";
    repo = "r128gain";
    rev = version;
    sha256 = "0fnxis2g7mw8mb0cz9bws909lrndli7ml54nnzda49vc2fhbjwxr";
  };

  patches = [
    (
      substituteAll {
        src = ./ffmpeg-location.patch;
        inherit ffmpeg;
      }
    )
  ];

  propagatedBuildInputs = with python3Packages; [ crcmod ffmpeg-python mutagen tqdm ];
  checkInputs = with python3Packages; [ requests sox ];

  # Testing downloads media files for testing, which requires the
  # sandbox to be disabled.
  doCheck = false;

  meta = with lib; {
    description = "Fast audio loudness scanner & tagger (ReplayGain v2 / R128)";
    homepage = "https://github.com/desbma/r128gain";
    license = licenses.lgpl2Plus;
    maintainers = [ maintainers.AluisioASG ];
    platforms = platforms.all;
  };
}
