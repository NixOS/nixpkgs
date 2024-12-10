{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  cmake,
  zlib,
  potrace,
  ffmpeg,
  libarchive,
  python3,
  qtbase,
  qttools,
  wrapQtAppsHook,
  testers,
  qtsvg,
  qtimageformats,
  # For the tests
  glaxnimate, # Call itself, for the tests
  xvfb-run,
}:
let
  # TODO: try to add a python library, see toPythonModule in doc/languages-frameworks/python.section.md
  python3WithLibs = python3.withPackages (
    ps: with ps; [
      # In data/lib/python-lottie/requirements.txt
      numpy
      pillow
      cairosvg
      fonttools
      grapheme
      opencv4
      pyqt5
      qscintilla
      # Not sure if needed, but appears in some files
      pyyaml
      requests
      pybind11
    ]
  );
in
stdenv.mkDerivation rec {
  pname = "glaxnimate";
  version = "0.5.4";

  src = fetchFromGitLab {
    owner = "mattbas";
    repo = "${pname}";
    rev = version;
    hash = "sha256-8oHJCQdP2xxSSDM0MDkSrG89WgCtMKm1AKlddnq3gig=";
    fetchSubmodules = true;
  };

  patches = [
    # Backport fix for newer ffmpeg
    # FIXME: remove in next update
    (fetchpatch {
      url = "https://invent.kde.org/graphics/glaxnimate/-/commit/4fb2b67a0f0ce2fbffb6fe9f87c3bf7914c8a602.patch";
      hash = "sha256-QjCnscGa7n+zwrImA4mbQiTQb9jmDGm8Y/7TK8jZXvM=";
    })
  ];

  nativeBuildInputs = [
    cmake
    wrapQtAppsHook
    qttools
  ];

  buildInputs = [
    zlib
    potrace
    # Upstream asks for libav dependency, which is fulfilled by ffmpeg
    ffmpeg
    libarchive
    qtbase
    qttools
    qtsvg
    qtimageformats
    python3WithLibs
  ];

  # Translation needs to be separately compiled
  # https://gitlab.com/mattbas/glaxnimate/-/issues/648
  buildFlags = [ "translations" ];

  qtWrapperArgs = [ ''--prefix PATH : ${python3WithLibs}/bin'' ];

  passthru.tests.version = lib.optionalAttrs stdenv.hostPlatform.isLinux (
    testers.testVersion {
      package = glaxnimate;
      command = "${xvfb-run}/bin/xvfb-run glaxnimate --version";
    }
  );

  meta = with lib; {
    homepage = "https://gitlab.com/mattbas/glaxnimate";
    description = "Simple vector animation program";
    license = licenses.gpl3;
    maintainers = with maintainers; [ tobiasBora ];
    mainProgram = "glaxnimate";
  };
}
