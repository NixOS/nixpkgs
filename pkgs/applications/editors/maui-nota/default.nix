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
, mauikit-texteditor
, qtmultimedia
, qtquickcontrols2
}:

mkDerivation rec {
  pname = "nota";
  version = "2.1.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "maui";
    repo = "nota";
    rev = "v${version}";
    sha256 = "sha256-Sgpm5njhQDe9ohAVFcN5iPNC6v9+QZnGRPYxuLvUno8=";
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
    mauikit-texteditor
    qtmultimedia
    qtquickcontrols2
  ];

  meta = with lib; {
    description = "Multi-platform text editor";
    homepage = "https://invent.kde.org/maui/nota";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ onny ];
  };
}
