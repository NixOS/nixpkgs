{ lib
, mkDerivation
, fetchFromGitHub
, qmake
, curl
, ffmpeg
, libmediainfo
, libzen
, qtbase
, qtdeclarative
, qtmultimedia
, qtsvg
, qttools
}:

mkDerivation rec {
  pname = "mediaelch";
  version = "2.8.10";

  src = fetchFromGitHub {
    owner = "Komet";
    repo = "MediaElch";
    rev = "v${version}";
    sha256 = "1ay36q1151lvlkzmbibwv84ic90ih2hzgwx34dndxxs034vbxjv8";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ curl libmediainfo libzen ffmpeg qtbase qtdeclarative qtmultimedia qtsvg ];

  prePatch = ''
    substituteInPlace MediaElch.pro --replace "/usr" "$out"
  '';

  meta = with lib; {
    homepage = "https://mediaelch.de/mediaelch/";
    description = "Media Manager for Kodi";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ stunkymonkey ];
    platforms = platforms.linux;
  };
}
