{ lib
, mkDerivation

, cmake
, extra-cmake-modules
, wrapGAppsHook3

, gst_all_1
, kconfig
, kcoreaddons
, ki18n
, kirigami-addons
, kirigami2
, networkmanager-qt
, qtkeychain
, qtmultimedia
, qtquickcontrols2
, syndication
, taglib
, threadweaver
}:

let
  inherit (gst_all_1) gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad;
in
mkDerivation rec {
  pname = "kasts";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    wrapGAppsHook3
  ];

  buildInputs = [
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gstreamer

    kconfig
    kcoreaddons
    ki18n
    kirigami-addons
    kirigami2
    networkmanager-qt
    qtkeychain
    qtmultimedia
    qtquickcontrols2
    syndication
    taglib
    threadweaver
  ];

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';
  dontWrapGApps = true;

  meta = with lib; {
    description = "Mobile podcast application";
    mainProgram = "kasts";
    homepage = "https://apps.kde.org/kasts/";
    # https://invent.kde.org/plasma-mobile/kasts/-/tree/master/LICENSES
    license = with licenses; [ bsd2 cc-by-sa-40 cc0 gpl2Only gpl2Plus gpl3Only gpl3Plus lgpl3Plus ];
    maintainers = [ ];
  };
}
