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
, mauikit-accounts
, mauikit-texteditor
, qtmultimedia
, qtquickcontrols2
}:

mkDerivation rec {
  pname = "buho";
  version = "2.1.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "maui";
    repo = "buho";
    rev = "v${version}";
    sha256 = "sha256-rHjjvjRY2WsyZfj3fzp46copZ1g2ae6PVv9lBNZDzcI=";
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
    mauikit-accounts
    mauikit-texteditor
    qtmultimedia
    qtquickcontrols2
  ];

  meta = with lib; {
    description = "Task and Note Keeper";
    homepage = "https://invent.kde.org/maui/buho";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ onny ];
  };
}
