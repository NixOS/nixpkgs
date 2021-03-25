{ lib
, stdenv
, fetchFromGitHub

, boca
, smooth
, systemd
}:

stdenv.mkDerivation rec {
  pname = "freac";
  version = "1.1.3";

  src = fetchFromGitHub {
    owner = "enzo1982";
    repo = "freac";
    rev = "v${version}";
    sha256 = "1sdrsc5pn5901bbds7dj02n71zn5rs4wnv2xxs8ffql4b7jjva0m";
  };

  buildInputs = [
    boca
    smooth
    systemd
  ];

  makeFlags = [
    "prefix=$(out)"
  ];

  meta = with lib; {
    description = "The fre:ac audio converter project";
    license = licenses.gpl2Plus;
    homepage = "https://www.freac.org/";
    maintainers = with maintainers; [ shamilton ];
    platforms = platforms.linux;
  };
}
