{
  lib,
  stdenv,
  fetchurl,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "gzrt";
  version = "0.8";

  src = fetchurl {
    url = "https://www.urbanophile.com/arenn/coding/gzrt/gzrt-${version}.tar.gz";
    sha256 = "1vhzazj47xfpbfhzkwalz27cc0n5gazddmj3kynhk0yxv99xrdxh";
  };

  buildInputs = [ zlib ];

  installPhase = ''
    mkdir -p $out/bin
    cp gzrecover $out/bin
  '';

<<<<<<< HEAD
  meta = {
=======
  meta = with lib; {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    homepage = "https://www.urbanophile.com/arenn/hacking/gzrt/";
    description = "Gzip Recovery Toolkit";
    maintainers = [ ];
    mainProgram = "gzrecover";
<<<<<<< HEAD
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
=======
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}
