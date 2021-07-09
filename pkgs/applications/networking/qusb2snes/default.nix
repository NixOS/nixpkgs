{ lib, fetchFromGitHub, mkDerivation, git, qmake, qtbase, qtserialport, qtwebsockets }:

mkDerivation rec {
  pname = "QUsb2snes";
  version = "0.7.19.1";

  src = fetchFromGitHub {
    owner = "Skarsnik";
    repo = "QUsb2snes";
    rev = "v${version}";
    sha256 = "1fj09sj072j3055dfjfbhzil0hqz2bv3mwv09477iz17bvifhf3k";
  };

  buildInputs = [ git qtbase qtserialport qtwebsockets ];
  nativeBuildInputs = [ qmake ];

  qmakeFlags = [ "${src}/QUsb2snes.pro" ];

  installPhase = ''
    mkdir -p $out/bin
    cp ./QUsb2Snes $out/bin
  '';

  meta = with lib; {
    description = "A Qt based webserver for usb2snes";
    license = licenses.gpl3Only;
    maintainers = [ maintainers.islandusurper ];
  };
}
