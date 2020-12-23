{ stdenv
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
}:

mkDerivation rec {
  pname = "mediaelch";
  version = "2.8.2";

  src = fetchFromGitHub {
    owner = "Komet";
    repo = "MediaElch";
    rev = "v${version}";
    sha256 = "0y26vfgrdym461lzmm5x3z5ai9ky09vlk3cy4sq6hwlj7mzcz0k7";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ qmake ];

  buildInputs = [ curl libmediainfo libzen ffmpeg qtbase qtdeclarative qtmultimedia ];

  prePatch = ''
    substituteInPlace MediaElch.pro --replace "/usr" "$out"
  '';

  meta = with stdenv.lib; {
    homepage = "https://mediaelch.de/mediaelch/";
    description = "Media Manager for Kodi";
    license = licenses.lgpl3Only;
    maintainers = with maintainers; [ stunkymonkey ];
    platforms = platforms.linux;
  };
}
