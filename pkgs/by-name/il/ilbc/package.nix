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
    url = "http://www.ietf.org/rfc/rfc3951.txt";
    sha256 = "0zf4mvi3jzx6zjrfl2rbhl2m68pzbzpf1vbdmn7dqbfpcb67jpdy";
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
