{ lib
, stdenv
, fetchFromGitHub
, wrapGAppsHook
, autoreconfHook
, pkg-config
, gtk3
, which
}:

stdenv.mkDerivation rec {
  pname = "xnec2c";
  version = "4.4.12";

  src = fetchFromGitHub {
    owner = "KJ7LNW";
    repo = "xnec2c";
    rev = "v${version}";
    sha256 = "sha256-1rgSVRmht2W0pKXqTU5BymLkm7MDspfAJXuPWSx07GY=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook wrapGAppsHook which ];
  buildInputs = [ gtk3 ];

  meta = with lib; {
    description = "Fast multi-threaded electromagnetic simulator based on NEC2";
    homepage = "https://www.xnec2c.org/";
    license = licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ melling ];
  };
}
