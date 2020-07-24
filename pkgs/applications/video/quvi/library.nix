{ stdenv, fetchurl, pkgconfig, lua5, curl, quvi_scripts, libproxy, libgcrypt, glib }:

stdenv.mkDerivation rec {
  pname = "libquvi";
  version="0.9.4";

  src = fetchurl {
    url = "mirror://sourceforge/quvi/libquvi-${version}.tar.xz";
    sha256 = "1cl1kbgxl1jnx2nwx4z90l0lap09lnnj1fg7hxsxk3m6aj4y4grd";
  };

  nativeBuildInputs = [ pkgconfig ];
  buildInputs = [ lua5 curl quvi_scripts libproxy libgcrypt glib ];

  meta = {
    description = "Web video downloader";
    homepage = "http://quvi.sf.net";
    license = stdenv.lib.licenses.lgpl21Plus;
    platforms = stdenv.lib.platforms.linux;
    maintainers = [ ];
  };
}
