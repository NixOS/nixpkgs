{ lib
, mkDerivation
, cmake
, extra-cmake-modules
, wrapGAppsHook
, gst_all_1
, kcoreaddons
, kdeclarative
, ki18n
, kirigami2
, mpv
, qtmultimedia
, qtquickcontrols2
, yt-dlp
}:

mkDerivation {
  pname = "plasmatube";

  nativeBuildInputs = [
    extra-cmake-modules
    wrapGAppsHook
  ];

  buildInputs = [
    kcoreaddons
    kdeclarative
    ki18n
    kirigami2
    mpv
    qtmultimedia
    qtquickcontrols2
  ] ++ (with gst_all_1; [
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gstreamer
  ]);

  patches = [
    ./0001-Add-placeholders-for-runtime-dependencies.patch
  ];

  postPatch = ''
    substituteInPlace src/videomodel.cpp \
      --replace "@yt-dlp@" "${yt-dlp}/bin/yt-dlp"
  '';

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';
  dontWrapGApps = true;

  meta = {
    description = "Youtube player powered by an invidious server";
    homepage = "https://invent.kde.org/plasma-mobile/plasmatube";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
