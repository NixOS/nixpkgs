{ lib, stdenv, fetchurl, pkg-config, lua5, curl, quvi_scripts, libproxy, libgcrypt, glib }:

stdenv.mkDerivation rec {
  pname = "libquvi";
  version="0.9.4";

  src = fetchurl {
    url = "mirror://sourceforge/quvi/libquvi-${version}.tar.xz";
    sha256 = "1cl1kbgxl1jnx2nwx4z90l0lap09lnnj1fg7hxsxk3m6aj4y4grd";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ lua5 curl quvi_scripts libproxy libgcrypt glib ];

  meta = {
    description = "Web video downloader";
    homepage = "http://quvi.sf.net";
    license = lib.licenses.lgpl21Plus;
    platforms = lib.platforms.linux;
    maintainers = [ ];
    broken = true; # missing glibc-2.34 support, no upstream activity
  };
}
