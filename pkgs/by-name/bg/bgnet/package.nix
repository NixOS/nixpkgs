{
  stdenv,
  lib,
  fetchFromGitHub,
  python3,
  pandoc,
}:

stdenv.mkDerivation {
  pname = "bgnet";
  # to be found in the Makefile
  version = "3.1.2";

  src = fetchFromGitHub {
    owner = "beejjorgensen";
    repo = "bgnet";
    rev = "782a785a35d43c355951b8151628d7c64e4d0346";
    hash = "sha256-Ivlo/ISFQxGlh9pDPWfxN79rB0aW46qSaM2Hk//IgKc=";
  };

  buildPhase = ''
    # build scripts need some love
    patchShebangs bin/preproc

    make -C src bgnet.html
  '';

  installPhase = ''
    install -Dm644 src/bgnet.html $out/share/doc/bgnet/html/index.html
  '';

  nativeBuildInputs = [
    python3
    pandoc
  ];

  meta = {
    description = "Beej’s Guide to Network Programming";
    homepage = "https://beej.us/guide/bgnet/";
    license = lib.licenses.unfree;

    maintainers = [ ];
  };
}
