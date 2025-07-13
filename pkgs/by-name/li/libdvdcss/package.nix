{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libdvdcss";
  version = "1.4.3";

  src = fetchurl {
    url = "https://get.videolan.org/libdvdcss/${version}/${pname}-${version}.tar.bz2";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  meta = with lib; {
    homepage = "http://www.videolan.org/developers/libdvdcss.html";
    description = "Library for decrypting DVDs";
    license = licenses.gpl2;
    platforms = platforms.unix;
  };
}
