{ lib
, fetchFromGitHub
, icu
, libkiwix
, meson
, ninja
, pkg-config
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "kiwix-tools";
  version = "3.4.0";

  src = fetchFromGitHub {
    owner = "kiwix";
    repo = "kiwix-tools";
    rev = version;
    sha256 = "sha256-r3/aTH/YoDuYpKLPakP4toS3OtiRueTUjmR34rdmr+w=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    icu
    libkiwix
  ];

  meta = with lib; {
    description = "Command line Kiwix tools: kiwix-serve, kiwix-manage, ...";
    homepage = "https://kiwix.org";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ colinsane ];
  };
}

