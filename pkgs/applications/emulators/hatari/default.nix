{ lib, stdenv, fetchurl, zlib, SDL, cmake }:

stdenv.mkDerivation rec {
  pname = "hatari";
  version = "2.3.1";

  src = fetchurl {
    url = "https://download.tuxfamily.org/hatari/${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-RKL2LKmV442eCHSAaVbwucPMhOqJ4BaaY4SbY807ZL0=";
  };

  # For pthread_cancel
  cmakeFlags = [ "-DCMAKE_EXE_LINKER_FLAGS=-lgcc_s" ];

  nativeBuildInputs = [ cmake ];
  buildInputs = [ zlib SDL ];

  meta = {
    homepage = "http://hatari.tuxfamily.org/";
    description = "Atari ST/STE/TT/Falcon emulator";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
}
