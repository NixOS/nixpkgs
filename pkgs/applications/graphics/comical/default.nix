{stdenv, fetchurl, wxGTK, utillinux, zlib }:

stdenv.mkDerivation {
  name = "comical-0.8";
  src = fetchurl {
    url = mirror://sourceforge/comical/comical-0.8.tar.gz;
    sha256 = "0b6527cc06b25a937041f1eb248d0fd881cf055362097036b939817f785ab85e";
  };
  buildInputs = [ wxGTK utillinux zlib ];
  patchPhase = ''
    sed -i -e 's@"zlib\\.h"@<zlib.h>@' unzip/unzip.h
    sed -i -e 's@/usr/local@'$out@ \
      -e 's@-lminiunzip@-lminiunzip -lz@' Makefile
  '';

  installPhase = "mkdir -p $out/bin ; make install";

  meta = {
    description = "Viewer of CBR and CBZ files, often used to store scanned comics";
    homepage = http://comical.sourceforge.net/;
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
