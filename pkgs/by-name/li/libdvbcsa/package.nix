{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libdvbcsa";
  version = "1.1.0";

  src = fetchurl {
    url = "http://get.videolan.org/libdvbcsa/${version}/${pname}-${version}.tar.gz";
    sha256 = "4db78af5cdb2641dfb1136fe3531960a477c9e3e3b6ba19a2754d046af3f456d";
  };

  doCheck = true;

  meta = {
    description = "Free implementation of the DVB Common Scrambling Algorithm with encryption and decryption capabilities";
    homepage = "http://www.videolan.org/developers/libdvbcsa.html";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ melias122 ];
  };

}
