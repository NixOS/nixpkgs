{ lib
, stdenv
, fetchFromGitLab
, cmake
, zlib
, potrace
, ffmpeg
, libarchive
, python3
, qtbase
, qttools
, wrapQtAppsHook
}:

stdenv.mkDerivation rec {
  pname = "glaxnimate";
  version = "0.5.1";

  src = fetchFromGitLab {
    owner = "mattbas";
    repo = "${pname}";
    rev = "${version}";
    sha256 = "G4ykcOvXXnVIQZUYpRIrALtDSsGqxMvDtcmobjjtlKw=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
  ];
  buildInputs = [
    zlib
    potrace
    ffmpeg
    # gst_all_1.gst-libav # Note that since gst-libav-1.6, libav is actually ffmpeg
    libarchive
    python3
    qtbase
    qttools
  ];

passthru.tests.version = testers.testVersion {
    package = glaxnimate;
    command = "glaxnimate --version";
  };
  meta = with lib; {
    homepage = "https://gitlab.com/mattbas/glaxnimate";
    description = "Simple vector animation program.";
    license = licenses.gpl3;
    maintainers = with maintainers; [ tobiasBora ];
  };
}
