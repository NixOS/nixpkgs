{stdenv, fetchurl, libX11, libXext, libSM, kdelibs, qt3, libjpeg, libungif, libpng, libtiff, imlib, arts, expat, perl}:

stdenv.mkDerivation {
  name = "kuickshow-0.8.5";
  builder = ./builder.sh;

  src = fetchurl {
    url = mirror://sourceforge/kuickshow/kuickshow-0.8.5.tgz;
    md5 = "7a95852a0670b18859a1e6789b256ebd";
  };

  configureFlags = "
    --with-imlib-config=${imlib}/bin
    --with-extra-includes=${libjpeg}/include
    --with-extra-libs=${libjpeg}/lib
    --x-includes=${libX11}/include
    --x-libraries=${libX11}/lib";

  buildInputs = [kdelibs libX11 libXext libSM qt3 libjpeg libungif libpng libtiff imlib arts expat perl];
  inherit libjpeg;

  KDEDIR = kdelibs;
}
