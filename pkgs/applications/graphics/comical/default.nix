<<<<<<< HEAD
{ lib
, stdenv
, fetchurl
, hexdump
, wxGTK32
, zlib
, Cocoa
}:
=======
{ lib, stdenv, fetchurl, wxGTK32, util-linux, zlib, Cocoa }:
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

stdenv.mkDerivation rec {
  pname = "comical";
  version = "0.8";

  src = fetchurl {
    url = "mirror://sourceforge/comical/comical-${version}.tar.gz";
<<<<<<< HEAD
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
=======
    sha256 = "0b6527cc06b25a937041f1eb248d0fd881cf055362097036b939817f785ab85e";
  };

  patches = [ ./wxgtk-3.2.patch ];

  buildInputs = [
    wxGTK32
    util-linux
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    zlib
  ] ++ lib.optionals stdenv.isDarwin [
    Cocoa
  ];

  makeFlags = [
    "prefix=${placeholder "out"}"
    "CC=${stdenv.cc.targetPrefix}cc"
    "CXX=${stdenv.cc.targetPrefix}c++"
  ];

<<<<<<< HEAD
  preInstall = ''
    mkdir -p $out/bin
  '';
=======
  preInstall = "mkdir -pv $out/bin";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  meta = {
    description = "Viewer of CBR and CBZ files, often used to store scanned comics";
    homepage = "https://comical.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ viric wegank ];
    platforms = with lib.platforms; unix;
    mainProgram = "comical";
  };
}
