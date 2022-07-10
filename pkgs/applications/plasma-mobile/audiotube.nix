{ lib
, mkDerivation

, extra-cmake-modules
, gcc11

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

  nativeBuildInputs = [
    extra-cmake-modules
    gcc11 # doesn't build with GCC 9 from stdenv on aarch64
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
  ] ++ pythonPath;

  pythonPath = with python3Packages; [
    yt-dlp
    ytmusicapi
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
