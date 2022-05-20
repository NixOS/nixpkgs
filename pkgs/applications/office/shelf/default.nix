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
, poppler
}:

mkDerivation rec {
  pname = "shelf";
  version = "2.1.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "maui";
    repo = "shelf";
    rev = "v${version}";
    sha256 = "sha256-0a5UHrYrkLR35cezjin+K9cTk3+aLeUAkvBbmKMK61w=";
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
    poppler
  ];

  meta = with lib; {
    description = "Document and EBook collection manager";
    homepage = "https://invent.kde.org/maui/shelf";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ onny ];
  };
}
