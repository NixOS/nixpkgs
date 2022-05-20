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
, taglib
, ffmpeg
}:

mkDerivation rec {
  pname = "clip";
  version = "2.1.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "maui";
    repo = "clip";
    rev = "v${version}";
    sha256 = "sha256-vW3A0PKJSC2QNs+QVZ9w0g4aVmcndhahrpkd4wWoUko=";
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
    taglib
    ffmpeg
  ];

  meta = with lib; {
    description = "Video player and video collection manager";
    homepage = "https://invent.kde.org/maui/clip";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ onny ];
  };
}
