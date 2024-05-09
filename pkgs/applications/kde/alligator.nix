{ lib
, mkDerivation

, cmake
, extra-cmake-modules

, kconfig
, kcoreaddons
, ki18n
, kirigami-addons
, kirigami2
, qtquickcontrols2
, syndication
}:

mkDerivation rec {
  pname = "alligator";

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    kconfig
    kcoreaddons
    ki18n
    kirigami-addons
    kirigami2
    qtquickcontrols2
    syndication
  ];

  meta = with lib; {
    description = "RSS reader made with kirigami";
    mainProgram = "alligator";
    homepage = "https://invent.kde.org/plasma-mobile/alligator";
    # https://invent.kde.org/plasma-mobile/alligator/-/commit/db30f159c4700244532b17a260deb95551045b7a
    #  * SPDX-License-Identifier: GPL-2.0-only OR GPL-3.0-only OR LicenseRef-KDE-Accepted-GPL
    license = with licenses; [ gpl2Only gpl3Only ];
    maintainers = with maintainers; [ samueldr ];
  };
}
