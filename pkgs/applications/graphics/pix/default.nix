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
, mauikit-imagetools
, qtmultimedia
, qtquickcontrols2
, qtlocation
, exiv2
, kquickimageedit
, fetchpatch
}:

mkDerivation rec {
  pname = "pix";
  version = "2.1.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "maui";
    repo = "pix";
    rev = "b33423213703a1e899f8a4b088737778b715a36a";
    sha256 = "sha256-RR32q2LMr9YWylUaY+c9zFLm97eMPP9OFj15EpWmtXo=";
  };

  patches = [
    # Fix build error. Commit which fixes this issue appeared afer
    # version 2.1.1 but should be fixed in later versions
    # https://invent.kde.org/maui/pix/-/commit/4c77aba5fc02e085d88e4182f353140cd57acef2
    (fetchpatch {
      url = "https://invent.kde.org/maui/pix/-/commit/4c77aba5fc02e085d88e4182f353140cd57acef2.patch";
      sha256 = "sha256-pNRnvjUiJ2cRhKk1wLl+keK48k2pIW5kl4dNFu0ngQg=";
    })
  ];

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
    mauikit-imagetools
    qtmultimedia
    qtquickcontrols2
    qtlocation
    exiv2
    kquickimageedit
  ];

  meta = with lib; {
    description = "Image gallery application";
    homepage = "https://invent.kde.org/maui/pix";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ onny ];
  };
}
