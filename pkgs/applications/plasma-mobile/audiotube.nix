{ lib
, mkDerivation
, fetchpatch

, extra-cmake-modules

, kcoreaddons
, kcrash
, ki18n
, kirigami2
, qtmultimedia
, qtquickcontrols2
, python3Packages
}:

mkDerivation rec {
  pname = "audiotube";

  patches = [
    # Fix compatibility with ytmusicapi 0.19.1
    (fetchpatch {
      url = "https://invent.kde.org/plasma-mobile/audiotube/-/commit/734caa02805988200f923b88d1590b3f7dac8ac2.patch";
      sha256 = "0zq4f0w84dv0630bpvmqkfmhxbvibr2fxhzy6d2mnf098028gzyd";
    })
  ];

  nativeBuildInputs = [
    extra-cmake-modules
    python3Packages.wrapPython
    python3Packages.pybind11
  ];

  buildInputs = [
    kcoreaddons
    kcrash
    ki18n
    kirigami2
    qtmultimedia
    qtquickcontrols2
    python3Packages.youtube-dl
    python3Packages.ytmusicapi
  ];

  pythonPath = [
    python3Packages.youtube-dl
    python3Packages.ytmusicapi
  ];

  preFixup = ''
    buildPythonPath "$pythonPath"
    qtWrapperArgs+=(--prefix PYTHONPATH : "$program_PYTHONPATH")
  '';

  meta = with lib; {
    description = "Client for YouTube Music";
    homepage = "https://invent.kde.org/plasma-mobile/audiotube";
    # https://invent.kde.org/plasma-mobile/audiotube/-/tree/c503d0607a3386112beaa9cf990ab85fe33ef115/LICENSES
    license = with licenses; [ bsd2 cc0 gpl2Only gpl3Only ];
    maintainers = with maintainers; [ samueldr ];
  };
}
