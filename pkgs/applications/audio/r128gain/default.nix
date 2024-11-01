{ lib
, callPackage
, fetchFromGitHub
, gitUpdater
, substituteAll
, ffmpeg
, python3Packages
, sox
, doCheck ? false
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
  nativeCheckInputs = with python3Packages; [ requests sox ];

  # The tests require unredistributable media files, so they're not run
  # by default.  Maintainers can override `doCheck` to toggle testing on
  # locally (provided building non-free packages is enabled).
  inherit doCheck;
  TEST_DL_CACHE_DIR = if doCheck then callPackage ./test-files.nix { } else null;

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
