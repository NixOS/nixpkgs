{ lib, stdenv, fetchurl, intltool, pkg-config, gtk2, fetchpatch }:

stdenv.mkDerivation rec {
  pname = "gpicview";
  version = "0.2.4";

  src = fetchurl {
    url = "mirror://sourceforge/lxde/gpicview-${version}.tar.gz";
    sha256 = "1svcy1c8bgk0pl12yhyv16h2fl52x5vzzcv57z6qdcv5czgvgglr";
  };

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/nonas/debian-clang/master/buildlogs/gpicview/gpicview-0.2.4/debian/patches/clang_FTBFS_Wreturn-type.patch";
      sha256 = "02dm966bplnv10knpdx7rlpjipk884156ggd9ij05zhza0jl8xcs";
    })
  ];

  nativeBuildInputs = [ pkg-config intltool ];

  buildInputs = [ gtk2 ];

  meta = with lib; {
    description = "A simple and fast image viewer for X";
    homepage = "https://lxde.sourceforge.net/gpicview/";
    license = licenses.gpl2;
    maintainers = with maintainers; [ lovek323 ];
    platforms = platforms.unix;
    mainProgram = "gpicview";
  };
}
