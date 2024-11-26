{ lib
, stdenv
, fetchFromGitHub
, makeWrapper
, tcl
, tk
, libX11
, zlib
}:

tcl.mkTclDerivation rec {
  pname = "scid";
  version = "5.0.2";

  src = fetchFromGitHub {
    owner = "benini";
    repo = "scid";
    rev = "v${version}";
    hash = "sha256-5WGZm7EwhZAMKJKxj/OOIFOJIgPBcc6/Bh4xVAlia4Y=";
  };

  postPatch = ''
    substituteInPlace configure \
      --replace "set var(INSTALL) {install_mac}" ""
  '';

  nativeBuildInputs = [
    makeWrapper
  ];

  buildInputs = [
    tk
    libX11
    zlib
  ];

  configureFlags = [
    "BINDIR=$(out)/bin"
    "SHAREDIR=$(out)/share"
  ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Chess database with play and training functionality";
    maintainers = with lib.maintainers; [ agbrooks ];
    homepage = "https://scid.sourceforge.net/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.all;
  };
}
