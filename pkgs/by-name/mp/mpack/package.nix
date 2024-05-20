{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "mpack";
  version = "1.6";

  src = fetchurl {
    url = "http://ftp.andrew.cmu.edu/pub/mpack/mpack-${version}.tar.gz";
    sha256 = "0k590z96509k96zxmhv72gkwhrlf55jkmyqlzi72m61r7axhhh97";
  };

  patches = [ ./build-fix.patch ./sendmail-via-execvp.diff ./CVE-2011-4919.patch ];

  postPatch = ''
    for f in *.{c,man,pl,unix} ; do
      substituteInPlace $f --replace /usr/tmp /tmp
    done

    # this just shuts up some warnings
    for f in {decode,encode,part,unixos,unixpk,unixunpk,xmalloc}.c ; do
      sed -i 'i#include <stdlib.h>' $f
    done
  '';

  postInstall = ''
    install -Dm644 -t $out/share/doc/mpack INSTALL README.*
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Utilities for encoding and decoding binary files in MIME";
    license = licenses.free;
    platforms = platforms.linux;
  };
}
