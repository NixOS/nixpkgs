{ lib
, mkDerivation
, extra-cmake-modules
, wrapGAppsHook3
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
    wrapGAppsHook3
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

  qtWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ yt-dlp ])
  ];

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';
  dontWrapGApps = true;

  meta = {
    description = "Youtube player powered by an invidious server";
    mainProgram = "plasmatube";
    homepage = "https://invent.kde.org/plasma-mobile/plasmatube";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
