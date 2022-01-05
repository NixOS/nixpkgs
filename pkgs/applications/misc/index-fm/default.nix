{ lib
, mkDerivation
, fetchFromGitLab
, cmake
, extra-cmake-modules
, applet-window-buttons
, karchive
, kcoreaddons
, ki18n
, kio
, kirigami2
, mauikit
, mauikit-filebrowsing
, qtmultimedia
, qtquickcontrols2
}:

mkDerivation rec {
  pname = "index-fm";
  version = "2.1.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "maui";
    repo = "index-fm";
    rev = "v${version}";
    sha256 = "sha256-Os/5igKGYBeY/FxO6I+7mpFohuk3yHGLd7vE2GewFpU=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
  ];

  buildInputs = [
    applet-window-buttons
    karchive
    kcoreaddons
    ki18n
    kio
    kirigami2
    mauikit
    mauikit-filebrowsing
    qtmultimedia
    qtquickcontrols2
  ];

  meta = with lib; {
    description = "Multi-platform file manager";
    homepage = "https://invent.kde.org/maui/index-fm";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ dotlambda ];
  };
}
