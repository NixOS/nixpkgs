{ stdenv, fetchFromGitHub, pkgconfig, qmake
, python, qtbase, qttools }:

stdenv.mkDerivation rec {
  pname = "tiled";
  version = "1.2.4";

  src = fetchFromGitHub {
    owner = "bjorn";
    repo = pname;
    rev = "v${version}";
    sha256 = "18a0pkq8j20v1njrl0sswm0ch10c6c4fas7q9kk2d2fd610ga6gh";
  };

  nativeBuildInputs = [ pkgconfig qmake ];
  buildInputs = [ python qtbase qttools ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Free, easy to use and flexible tile map editor";
    homepage = https://www.mapeditor.org/;
    license = with licenses; [
      bsd2	# libtiled and tmxviewer
      gpl2Plus	# all the rest
    ];
    maintainers = with maintainers; [ dywedir ];
    platforms = platforms.linux;
  };
}
