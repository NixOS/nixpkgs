{ lib, stdenv
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
  version = "2.8.6";

  src = fetchFromGitHub {
    owner = "Komet";
    repo = "MediaElch";
    rev = "v${version}";
    sha256 = "1134vw7hr0mpqcsxjq4bqmg5760dngz17bzj97ypfc5cvzcxjh43";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [ qmake ];

  buildInputs = [ curl libmediainfo libzen ffmpeg qtbase qtdeclarative qtmultimedia ];

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
