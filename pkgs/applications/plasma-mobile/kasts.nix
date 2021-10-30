{ lib
, mkDerivation

, cmake
, extra-cmake-modules
, wrapGAppsHook

, gst_all_1
, kconfig
, kcoreaddons
, ki18n
, kirigami2
, qtmultimedia
, qtquickcontrols2
, syndication
}:

let
  inherit (gst_all_1) gstreamer gst-plugins-base gst-plugins-good gst-plugins-bad;
in
mkDerivation rec {
  pname = "kasts";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    wrapGAppsHook
  ];

  buildInputs = [
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gstreamer

    kconfig
    kcoreaddons
    ki18n
    kirigami2
    qtquickcontrols2
    qtmultimedia
    syndication
  ];

  preFixup = ''
    qtWrapperArgs+=("''${gappsWrapperArgs[@]}")
  '';
  dontWrapGApps = true;

  meta = with lib; {
    description = "Mobile podcast application";
    homepage = "https://apps.kde.org/kasts/";
    # https://invent.kde.org/plasma-mobile/kasts/-/tree/master/LICENSES
    license = with licenses; [ bsd2 cc-by-sa-40 cc0 gpl2Only gpl2Plus gpl3Only gpl3Plus lgpl3Plus ];
    maintainers = with maintainers; [ samueldr ];
  };
}
