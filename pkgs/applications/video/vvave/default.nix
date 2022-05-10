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
, mauikit-accounts
, mauikit-filebrowsing
, qtmultimedia
, qtquickcontrols2
, taglib
}:

mkDerivation rec {
  pname = "vvave";
  version = "2.1.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "maui";
    repo = "vvave";
    rev = "v${version}";
    sha256 = "sha256-ykX1kd3106KTDTJQIGk6miSgbj+oROiXQl/nkCjTphE=";
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
    mauikit-accounts
    mauikit-filebrowsing
    qtmultimedia
    qtquickcontrols2
    taglib
  ];

  meta = with lib; {
    description = "Multi-platform media player";
    homepage = "https://invent.kde.org/maui/vvave";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ onny ];
  };
}

