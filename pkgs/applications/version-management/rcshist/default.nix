{ lib
, stdenv
, fetchurl
}:

stdenv.mkDerivation {
  pname = "rcshist";
  version = "1.04";

  src = fetchurl {
    url = "https://web.archive.org/web/20220508220019/https://invisible-island.net/datafiles/release/rcshist.tar.gz";
    sha256 = "01ab3xwgm934lxr8bm758am3vxwx4hxx7cc9prbgqj5nh30vdg1n";
  };

  meta = {
    description = "Utitity to display complete revision history of a set of RCS files";
    homepage = "https://invisible-island.net/rcshist/rcshist.html";
    license = lib.licenses.bsd2;
    maintainers = [ lib.maintainers.kaction ];
    platforms = lib.platforms.unix;
  };
}
