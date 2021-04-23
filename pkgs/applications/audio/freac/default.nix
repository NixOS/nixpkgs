{ lib
, stdenv
, fetchFromGitHub

, boca
, smooth
, systemd
}:

stdenv.mkDerivation rec {
  pname = "freac";
  version = "1.1.4";

  src = fetchFromGitHub {
    owner = "enzo1982";
    repo = "freac";
    rev = "v${version}";
    sha256 = "sha256-JwZJOV4mxNKqhhdlfFcX06NwBxmbye2mgMfdM//bHYI=";
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
