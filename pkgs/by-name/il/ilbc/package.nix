{
  lib,
  stdenv,
  fetchurl,
  gawk,
  cmake,
}:

stdenv.mkDerivation rec {
  name = "ilbc-rfc3951";

  script = ./extract-cfile.awk;

  rfc3951 = fetchurl {
    url = "https://www.ietf.org/rfc/rfc3951.txt";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  nativeBuildInputs = [ cmake ];

  unpackPhase = ''
    mkdir -v ${name}
    cd ${name}
    ${gawk}/bin/gawk -f ${script} ${rfc3951}
    cp -v ${./CMakeLists.txt} CMakeLists.txt
  '';

  meta = {
    platforms = lib.platforms.unix;
  };
}
