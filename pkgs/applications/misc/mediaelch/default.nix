{ lib
, mkDerivation
, fetchFromGitHub

, qmake
, qttools

, curl
, ffmpeg
, libmediainfo
, libzen
, qtbase
, qtdeclarative
, qtmultimedia
, qtsvg
}:

mkDerivation rec {
  pname = "mediaelch";
  version = "2.8.12";

  src = fetchFromGitHub {
    owner = "Komet";
    repo = "MediaElch";
    rev = "v${version}";
    sha256 = "1gx4m9cf81d0b2nk2rlqm4misz67f5bpkjqx7d1l76rw2pwc6azf";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ curl ffmpeg libmediainfo libzen qtbase qtdeclarative qtmultimedia qtsvg ];

  prePatch = ''
    substituteInPlace MediaElch.pro --replace "/usr" "$out"
  '';

  qtWrapperArgs = [
    # libmediainfo.so.0 is loaded dynamically
    "--prefix LD_LIBRARY_PATH : ${libmediainfo}/lib"
  ];

  meta = with lib; {
    homepage = "https://mediaelch.de/mediaelch/";
    description = "Media Manager for Kodi";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ stunkymonkey ];
    platforms = platforms.linux;
  };
}
