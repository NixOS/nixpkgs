{ lib
, fetchFromGitHub
, gitUpdater
, icu
, libkiwix
, meson
, ninja
, pkg-config
, stdenv
}:

stdenv.mkDerivation rec {
  pname = "kiwix-tools";
  version = "3.5.0";

  src = fetchFromGitHub {
    owner = "kiwix";
    repo = "kiwix-tools";
    rev = version;
    sha256 = "sha256-bOxi51H28LhA+5caX6kllIY5B3Q1FoGVFadFIhYRkG0=";
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

  passthru.updateScript = gitUpdater { };

  meta = with lib; {
    description = "Command line Kiwix tools: kiwix-serve, kiwix-manage, ...";
    homepage = "https://kiwix.org";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ colinsane ];
  };
}

