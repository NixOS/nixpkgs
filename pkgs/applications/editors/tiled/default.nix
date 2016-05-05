{ stdenv, fetchurl, pkgconfig, qmakeHook
, python, qtbase, qttools, zlib }:

let
#  qtEnv = with qt5; env "qt-${qtbase.version}" [ qtbase qttools ];
in stdenv.mkDerivation rec {
  name = "tiled-${version}";
  version = "0.16.0";

  src = fetchurl {
    name = "${name}.tar.gz";
    url = "https://github.com/bjorn/tiled/archive/v${version}.tar.gz";
    sha256 = "1vlhfkgl126irp53xw94jw1xnj96l1hwnbxmm1s5az60460gfbf0";
  };

  nativeBuildInputs = [ pkgconfig qmakeHook ];
  buildInputs = [ python qtbase qttools ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Free, easy to use and flexible tile map editor";
    homepage = http://www.mapeditor.org/;
    license = with licenses; [
      bsd2	# libtiled and tmxviewer
      gpl2Plus	# all the rest
    ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ nckx ];
  };
}
