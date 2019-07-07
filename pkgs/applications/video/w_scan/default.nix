{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "w_scan-${version}";
  version = "20170107";

  src = fetchurl {
    url = "http://wirbel.htpc-forum.de/w_scan/${name}.tar.bz2";
    sha256 = "1zkgnj2sfvckix360wwk1v5s43g69snm45m0drnzyv7hgf5g7q1q";
  };

  meta = {
    description = "Small CLI utility to scan DVB and ATSC transmissions";
    homepage = http://wirbel.htpc-forum.de/w_scan/index_en.html;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.nico202 ] ;
    license = stdenv.lib.licenses.gpl2;
  };
}
