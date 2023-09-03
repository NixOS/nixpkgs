{ lib
, stdenv
, fetchurl
, pkg-config
, cmake
, hunspell
, qtbase
, qtmultimedia
, qttools
, qt5compat
}:

stdenv.mkDerivation rec {
  pname = "focuswriter";
  version = "1.8.5";

  src = fetchurl {
    url = "https://gottcode.org/focuswriter/focuswriter-${version}.tar.bz2";
    sha256 = "sha256-O0GHzpA8Vap/rWiLF2j9zMyfAm2ko1Vk3KqZyyvudlQ=";
  };

  nativeBuildInputs = [ pkg-config cmake qttools ];
  buildInputs = [ hunspell qtbase qtmultimedia qt5compat ];

  # Causes an error during compilation if not set
  dontWrapQtApps = true;

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  meta = with lib; {
    description = "Simple, distraction-free writing environment";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ madjar kashw2 ];
    platforms = platforms.linux;
    homepage = "https://gottcode.org/focuswriter/";
  };
}
