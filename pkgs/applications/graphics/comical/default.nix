{ lib, stdenv, fetchurl, wxGTK32, util-linux, zlib, Cocoa }:

stdenv.mkDerivation rec {
  pname = "comical";
  version = "0.8";

  src = fetchurl {
    url = "mirror://sourceforge/comical/comical-${version}.tar.gz";
    sha256 = "0b6527cc06b25a937041f1eb248d0fd881cf055362097036b939817f785ab85e";
  };

  patches = [ ./wxgtk-3.2.patch ];

  buildInputs = [
    wxGTK32
    util-linux
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    Cocoa
  ];

  makeFlags = [
    "prefix=${placeholder "out"}"
    "CC=${stdenv.cc.targetPrefix}cc"
    "CXX=${stdenv.cc.targetPrefix}c++"
  ];

  preInstall = "mkdir -pv $out/bin";

  meta = {
    description = "Viewer of CBR and CBZ files, often used to store scanned comics";
    homepage = "https://comical.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ viric wegank ];
    platforms = with lib.platforms; unix;
    mainProgram = "comical";
  };
}
