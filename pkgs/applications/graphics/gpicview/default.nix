{ stdenv, fetchurl, intltool, pkgconfig, gtk2, fetchpatch }:

stdenv.mkDerivation {
  name = "gpicview-0.2.4";

  src = fetchurl {
    url    = "mirror://sourceforge/lxde/gpicview-0.2.4.tar.gz";
    sha256 = "1svcy1c8bgk0pl12yhyv16h2fl52x5vzzcv57z6qdcv5czgvgglr";
  };

  patches = [
    (fetchpatch {
      url = "https://raw.githubusercontent.com/nonas/debian-clang/master/buildlogs/gpicview/gpicview-0.2.4/debian/patches/clang_FTBFS_Wreturn-type.patch";
      sha256 = "02dm966bplnv10knpdx7rlpjipk884156ggd9ij05zhza0jl8xcs";
    })
  ];

  meta = with stdenv.lib; {
    description = "A simple and fast image viewer for X";
    homepage    = "http://lxde.sourceforge.net/gpicview/";
    repositories.git = "git://lxde.git.sourceforge.net/gitroot/lxde/gpicview";
    license     = licenses.gpl2;
    maintainers = with maintainers; [ lovek323 ];
    platforms   = platforms.unix;
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ intltool gtk2 ];
}
