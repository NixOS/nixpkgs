{ lib, stdenv, fetchurl, lzip, lzlib, texinfo }:

stdenv.mkDerivation (finalAttrs: {
  pname = "plzip";
  version = "1.11";
  outputs = [ "out" "man" "info" ];

  src = fetchurl {
    url = "mirror://savannah/lzip/plzip/plzip-${finalAttrs.version}.tar.lz";
    sha256 = "51f48d33df659bb3e1e7e418275e922ad752615a5bc984139da08f1e6d7d10fd";
    # hash from release email
  };

  nativeBuildInputs = [ lzip texinfo ];
  buildInputs = [ lzlib ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = {
    homepage = "https://www.nongnu.org/lzip/plzip.html";
    description = "Massively parallel lossless data compressor based on the lzlib compression library";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ _360ied ehmry ];
    mainProgram = "plzip";
  };
})
