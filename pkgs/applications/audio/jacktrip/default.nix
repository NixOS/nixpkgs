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
}:

mkDerivation rec {
  version = "1.5.3";
  pname = "jacktrip";

  src = fetchFromGitHub {
    owner = "jacktrip";
    repo = "jacktrip";
    rev = "v${version}";
    sha256 = "sha256-sfAYMTnBjT4LkgksyzDGGy97NLX5ljjhNDFioQnTzLs=";
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
