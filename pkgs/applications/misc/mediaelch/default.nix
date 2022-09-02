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
, quazip
}:

mkDerivation rec {
  pname = "mediaelch";
  version = "2.8.16";

  src = fetchFromGitHub {
    owner = "Komet";
    repo = "MediaElch";
    rev = "v${version}";
    sha256 = "sha256-83bHfIRVAC+3RkCYmV+TBjjQxaFMHfVyxt5Jq44dzeI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ qmake qttools ];

  buildInputs = [ curl ffmpeg libmediainfo libzen qtbase qtdeclarative qtmultimedia qtsvg ];

  qmakeFlags = [
    "USE_EXTERN_QUAZIP=${quazip}/include/quazip5"
  ];

  postPatch = ''
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
