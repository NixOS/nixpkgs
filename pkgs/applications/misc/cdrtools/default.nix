{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "cdrtools-2.01";

  configurePhase = "prefix=$out";

  #hack, I'm getting "chown: invalid user: `bin" error, so replace chown by a nop dummy script
  preInstall = ''
    mkdir "$TMP/bin"
    for i in chown chgrp; do
      echo '#!/bin/sh' >> "$TMP/bin/$i"
      chmod +x "$TMP/bin/$i"
      PATH="$TMP/bin:$PATH"
    done
  '';

  src = fetchurl {
    url = "mirror://sourceforge/cdrtools/${name}.tar.bz2";
    sha256 = "08kc5w4z5k2ka7i05an7gfzzp0fsrc403riav7bw8xws0rsn32vj";
  };

  patches = [./cdrtools-2.01-install.patch];

  meta = {
    homepage = http://sourceforge.net/projects/cdrtools/;
    description = "Highly portable CD/DVD/BluRay command line recording software";
    broken = true;              # Build errors, probably because the source
                                # can't deal with recent versions of gcc.
  };
}
