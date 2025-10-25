{
  lib,
  stdenv,
  fetchFromGitHub,
  makeWrapper,
  tcl,
  tk,
  libX11,
  zlib,
}:

tcl.mkTclDerivation rec {
  pname = "scid";
  version = "5.1.0";

  src = fetchFromGitHub {
    owner = "benini";
    repo = "scid";
    rev = "v${version}";
    hash = "sha256-xO5Jye2U1NpWT0Nrb+7dUW4QiJrFfxro1w8JZr8z4+8=";
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
