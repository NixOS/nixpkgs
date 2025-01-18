{
  lib,
  stdenv,
  fetchurl,
  hexdump,
  wxGTK32,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "comical";
  version = "0.8";

  src = fetchurl {
    url = "mirror://sourceforge/comical/comical-${version}.tar.gz";
    hash = "sha256-C2UnzAayWpNwQfHrJI0P2IHPBVNiCXA2uTmBf3hauF4=";
  };

  patches = [
    ./wxgtk-3.2.patch
  ];

  nativeBuildInputs = [
    hexdump
  ];

  buildInputs = [
    wxGTK32
    zlib
  ];

  makeFlags = [
    "prefix=${placeholder "out"}"
    "CC=${stdenv.cc.targetPrefix}cc"
    "CXX=${stdenv.cc.targetPrefix}c++"
  ];

  env.NIX_CFLAGS_COMPILE = "-Wno-error=incompatible-pointer-types";

  preInstall = ''
    mkdir -p $out/bin
  '';

  meta = with lib; {
    description = "Viewer of CBR and CBZ files, often used to store scanned comics";
    homepage = "https://comical.sourceforge.net/";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ wegank ];
    platforms = with platforms; unix;
    mainProgram = "comical";
  };
}
