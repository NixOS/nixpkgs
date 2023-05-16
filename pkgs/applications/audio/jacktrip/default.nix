{ lib, mkDerivation, fetchFromGitHub
, pkg-config
, help2man
, qmake
, alsa-lib
, libjack2
, dbus
, qtbase
, qttools
, qtx11extras
, meson
, python3
, rtaudio
, ninja
<<<<<<< HEAD
, qtquickcontrols2
, qtnetworkauth
, qtwebsockets
, qtgraphicaleffects
}:

mkDerivation rec {
  version = "1.10.1";
=======
}:

mkDerivation rec {
  version = "1.5.3";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "jacktrip";

  src = fetchFromGitHub {
    owner = "jacktrip";
    repo = "jacktrip";
    rev = "v${version}";
<<<<<<< HEAD
    fetchSubmodules = true;
    sha256 = "sha256-bdYhyLsdL4LDkCzJiWXdi+7CTtqhSiA7HNYhg190NWs=";
=======
    sha256 = "sha256-sfAYMTnBjT4LkgksyzDGGy97NLX5ljjhNDFioQnTzLs=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  preConfigure = ''
    rm build
  '';

  buildInputs = [
    rtaudio
    qtbase
    qtx11extras
    libjack2
    dbus
  ];

  nativeBuildInputs = [
    python3
    python3.pkgs.pyaml
    python3.pkgs.jinja2
    ninja
    help2man
    meson
    qmake
    qttools
<<<<<<< HEAD
    qtquickcontrols2
    qtnetworkauth
    qtwebsockets
    qtgraphicaleffects
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    pkg-config
  ];

  qmakeFlags = [ "jacktrip.pro" ];

  meta = with lib; {
    description = "Multi-machine audio network performance over the Internet";
    homepage = "https://jacktrip.github.io/jacktrip/";
    license = with licenses; [ gpl3 lgpl3 mit ];
    maintainers = [ maintainers.iwanb ];
    platforms = platforms.linux;
  };
}
