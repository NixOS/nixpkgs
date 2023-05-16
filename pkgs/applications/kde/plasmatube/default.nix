{ lib
, mkDerivation
<<<<<<< HEAD
=======
, cmake
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
, yt-dlp
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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

<<<<<<< HEAD
  qtWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [ yt-dlp ])
  ];

=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
