{
  lib,
  stdenv,
  fetchurl,
  bison,
}:

stdenv.mkDerivation rec {
  pname = "as31";
  version = "2.3.1";

  src = fetchurl {
    url = "http://wiki.erazor-zone.de/_media/wiki:projects:linux:as31:${pname}-${version}.tar.gz";
    name = "${pname}-${version}.tar.gz";
    hash = "sha256-zSEyWHFon5nyq717Mpmdv1XZ5Hz0e8ZABqsP8M83c1U=";
  };

  patches = [
    # Check return value of getline in run.c
    ./0000-getline-break.patch
  ];

  postPatch = ''
    # parser.c is generated from parser.y; it is better to generate it via bison
    # instead of using the prebuilt one, especially in x86_64
    rm -f as31/parser.c
  '';

  preConfigure = ''
    chmod +x configure
  '';

  nativeBuildInputs = [
    bison
  ];

  meta = with lib; {
    homepage = "http://wiki.erazor-zone.de/wiki:projects:linux:as31";
    description = "8031/8051 assembler";
    mainProgram = "as31";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.unix;
  };
}
