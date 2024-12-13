{
  lib,
  stdenv,
  fetchurl,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "ctpp2";
  version = "2.8.3";

  src = fetchurl {
    url = "https://ctpp.havoc.ru/download/${pname}-${version}.tar.gz";
    sha256 = "1z22zfw9lb86z4hcan9hlvji49c9b7vznh7gjm95gnvsh43zsgx8";
  };

  nativeBuildInputs = [ cmake ];

  patchPhase = ''
    # include <unistd.h> to fix undefined getcwd
    sed -ie 's/<stdlib.h>/<stdlib.h>\n#include <unistd.h>/' src/CTPP2FileSourceLoader.cpp
  '';

  cmakeFlags = [
    # RPATH of binary /nix/store/.../bin/ctpp2json contains a forbidden reference to /build/
    "-DCMAKE_SKIP_BUILD_RPATH=ON"
  ];

  doCheck = false; # fails

  meta = with lib; {
    description = "High performance templating engine";
    homepage = "https://ctpp.havoc.ru/";
    maintainers = [ maintainers.robbinch ];
    platforms = platforms.linux;
    license = licenses.bsd2;
  };
}
