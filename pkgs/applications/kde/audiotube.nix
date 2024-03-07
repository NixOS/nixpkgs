{ lib
, mkDerivation

, extra-cmake-modules
, wrapGAppsHook

, futuresql
, gst_all_1
, kcoreaddons
, kcrash
, ki18n
, kirigami2
, kirigami-addons
, qcoro
, qtimageformats
, qtmultimedia
, qtquickcontrols2
, python3Packages
}:

mkDerivation rec {
  pname = "audiotube";

  nativeBuildInputs = [
    extra-cmake-modules
    wrapGAppsHook
    python3Packages.wrapPython
    python3Packages.pybind11
  ];

  buildInputs = [
    futuresql
    kcoreaddons
    kcrash
    ki18n
    kirigami2
    kirigami-addons
    qcoro
    qtimageformats
    qtmultimedia
    qtquickcontrols2
  ] ++ (with gst_all_1; [
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gstreamer
  ]) ++ pythonPath;

  pythonPath = with python3Packages; [
    yt-dlp
    ytmusicapi
  ];

  preFixup = ''
    buildPythonPath "$pythonPath"
    qtWrapperArgs+=(--prefix PYTHONPATH : "$program_PYTHONPATH")
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';
  dontWrapGApps = true;

  meta = with lib; {
    description = "Client for YouTube Music";
    homepage = "https://invent.kde.org/plasma-mobile/audiotube";
    # https://invent.kde.org/plasma-mobile/audiotube/-/tree/c503d0607a3386112beaa9cf990ab85fe33ef115/LICENSES
    license = with licenses; [ bsd2 cc0 gpl2Only gpl3Only ];
    maintainers = with maintainers; [ samueldr ];
  };
}
