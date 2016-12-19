{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "w_scan-${version}";
  version = "20161022";

  src = fetchurl {
    url = "http://wirbel.htpc-forum.de/w_scan/${name}.tar.bz2";
    sha256 = "0y8dq2sm13xn2r2lrqf5pdhr9xcnbxbg1aw3iq1szds2idzsyxr0";
  };

  meta = {
    description = "Small CLI utility to scan DVB and ATSC transmissions";
    homepage = http://wirbel.htpc-forum.de/w_scan/index_en.html;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.nico202 ] ;
    license = stdenv.lib.licenses.gpl2;
  };
}
