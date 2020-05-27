{ stdenv, fetchurl, perl, pkgsi686Linux }:

pkgsi686Linux.stdenv.mkDerivation {
  name = "dvb-apps-3d43b280298c";

  src = fetchurl {
    url = "https://www.linuxtv.org/hg/dvb-apps/archive/3d43b280298c.tar.bz2";
    sha256 = "0mz02mz4j945c53vdwaxrpy6fks19nnn482jhg72pqyppq72z7pk";
  };

  buildInputs = [ perl pkgsi686Linux.glibc.static ];

  patches = [
    ./0003-handle-static-shared-only-build.patch
    ./0005-utils-fix-build-with-kernel-headers-4.14.patch
    ./linuxtv-dvb-apps-1.1.1.20100223-perl526.patch
    ./0001-dvbdate-Remove-Obsoleted-stime-API-calls.patch
  ];

  dontConfigure = true; # skip configure

  installPhase = "make prefix=$out install";

  meta = {
    description = "Linux DVB API applications and utilities";
    homepage = "https://linuxtv.org/";
    platforms = stdenv.lib.platforms.linux;
    license = stdenv.lib.licenses.gpl2;
  };
}
