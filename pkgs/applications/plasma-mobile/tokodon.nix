{ lib
, mkDerivation

, cmake
, extra-cmake-modules
, pkg-config

, kconfig
, kdbusaddons
, ki18n
, kirigami2
, kirigami-addons
, knotifications
, libwebsockets
, qqc2-desktop-style
, qtbase
, qtkeychain
, qtmultimedia
, qtquickcontrols2
, qttools
, qtwebsockets
, kitemmodels
, pimcommon

# Workarounds for the point release being missing.
, libsForQt5
, fetchFromGitLab
}:

# NOTE: we cannot use `mkDerivation` injected by the Plasma Mobile package
#       set for the point release, as the point release was not uploaded to
#       the Plasma Mobile gear repo, and the injected `mkDerivation` only can
#       use the src (and version) from the `srcs` set.
libsForQt5.mkDerivation rec {
  pname = "tokodon";

  version = "23.01.0";
  # NOTE: the tokodon point release was not uploaded to the Plasma Mobile gear repo.
  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "network";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-iJRyKEFdoWtZLZ/nkMvy2S7EF+JRHXi3O0DswfrClDU=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    pkg-config
  ];

  buildInputs = [
    kconfig
    kdbusaddons
    ki18n
    kirigami2
    kirigami-addons
    knotifications
    qqc2-desktop-style
    qtbase
    qtkeychain
    qtmultimedia
    qtquickcontrols2
    qttools
    qtwebsockets
    kitemmodels
    pimcommon
  ];

  meta = with lib; {
    description = "A Mastodon client for Plasma and Plasma Mobile";
    homepage = "https://invent.kde.org/network/tokodon";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ matthiasbeyer ];
  };
}
