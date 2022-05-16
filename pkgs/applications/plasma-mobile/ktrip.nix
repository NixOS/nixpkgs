{ lib
, mkDerivation
, fetchpatch

, cmake
, extra-cmake-modules

, kconfig
, kcontacts
, kcoreaddons
, ki18n
, kirigami-addons
, kirigami2
, kitemmodels
, kpublictransport
, qqc2-desktop-style
, qtquickcontrols2
}:

mkDerivation rec {
  pname = "ktrip";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  patches = [
    (fetchpatch {
      name = "fix-kf5-build.patch";
      url = "https://invent.kde.org/utilities/ktrip/commit/3459a376ca1a3df629d97676cdf2e9fcebb5eccb.patch";
      sha256 = "sha256-f1B9o3jCHvrMebN0voDxcsM57DGrCqYE15IEI++LGQU=";
    })
  ];

  buildInputs = [
    kconfig
    kcontacts
    kcoreaddons
    ki18n
    kirigami-addons
    kirigami2
    kitemmodels
    kpublictransport
    qqc2-desktop-style
    qtquickcontrols2
  ];

  meta = with lib; {
    description = "Public transport trip planner";
    homepage = "https://apps.kde.org/ktrip/";
    # GPL-2.0-or-later
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ samueldr ];
  };
}
