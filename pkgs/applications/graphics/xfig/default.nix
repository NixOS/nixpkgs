{ stdenv, fetchurl, makeWrapper, imake
, x11, libXpm, libXmu, libXi, libXp, Xaw3d, libpng, libjpeg}:

stdenv.mkDerivation {
  name = "xfig-3.2.5-pre-alpha-5";

  src = fetchurl {
    url = http://xfig.org/software/xfig/3.2.5-alpha/xfig.3.2.5-alpha5.full.tar.gz;
    md5 = "7547b66232569e3c12e4a0639bd92629";
  };

  builder = ./builder.sh;

  buildInputs = [imake x11 libXpm libXmu libXi libXp Xaw3d libpng libjpeg makeWrapper];

  NIX_CFLAGS_COMPILE = "-I${libXpm}/include/X11";

  meta = {
    description = "An interactive drawing tool for X11";
    homepage = http://xfig.org;
  };
}
