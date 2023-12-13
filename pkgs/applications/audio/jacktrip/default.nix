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
, qtquickcontrols2
, qtnetworkauth
, qtwebsockets
, qtgraphicaleffects
}:

mkDerivation rec {
  version = "1.10.1";
  pname = "jacktrip";

  src = fetchFromGitHub {
    owner = "jacktrip";
    repo = "jacktrip";
    rev = "v${version}";
    fetchSubmodules = true;
    sha256 = "sha256-bdYhyLsdL4LDkCzJiWXdi+7CTtqhSiA7HNYhg190NWs=";
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
    qtquickcontrols2
    qtnetworkauth
    qtwebsockets
    qtgraphicaleffects
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
