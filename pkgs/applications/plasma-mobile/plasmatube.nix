{ lib
, mkDerivation
, cmake
, extra-cmake-modules
, gst_all_1
, kcoreaddons
, kdeclarative
, ki18n
, kirigami2
, qtmultimedia
, qtquickcontrols2
}:

mkDerivation {
  pname = "plasmatube";

  nativeBuildInputs = [
    extra-cmake-modules
  ];

  buildInputs = [
    kcoreaddons
    kdeclarative
    ki18n
    kirigami2
    qtmultimedia
    qtquickcontrols2
  ] ++ (with gst_all_1; [
    gst-plugins-bad
    gst-plugins-base
    gst-plugins-good
    gstreamer
  ]);

  meta = {
    description = "Youtube player powered by an invidious server";
    homepage = "https://invent.kde.org/plasma-mobile/plasmatube";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
