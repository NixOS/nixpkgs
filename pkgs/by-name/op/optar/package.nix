{
  lib,
  stdenv,
  fetchurl,
  imagemagick,
  libpng,
}:

stdenv.mkDerivation {
  pname = "optar";
  version = "20150210";

  src = fetchurl {
    url = "http://ronja.twibright.com/optar.tgz";
    sha256 = "10lr31k3xfcpa6vxkbl3abph7j3gks2210489khnnzmhmfdnm1a4";
  };

  buildInputs = [ libpng ];

  enableParallelBuilding = true;

  postPatch = ''
    substituteInPlace Makefile \
      --replace /usr/local $out

    substituteInPlace pgm2ps \
      --replace 'convert ' "${lib.getBin imagemagick}/bin/convert "
  '';

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = with lib; {
    description = "OPTical ARchiver - it's a codec for encoding data on paper";
    homepage = "http://ronja.twibright.com/optar/";
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = with platforms; linux; # possibly others, but only tested on Linux
  };
}
