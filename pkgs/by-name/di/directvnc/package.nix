{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  autoreconfHook,
  pkg-config,
  directfb,
  zlib,
  libjpeg,
  xorgproto,
}:

stdenv.mkDerivation {
  pname = "directvnc";
  version = "0.7.7.2015-04-16";

  src = fetchFromGitHub {
    owner = "drinkmilk";
    repo = "directvnc";
    rev = "d336f586c5865da68873960092b7b5fbc9f8617a";
    sha256 = "16x7mr7x728qw7nbi6rqhrwsy73zsbpiz8pbgfzfl2aqhfdiz88b";
  };

  patches = [
    # Pull fix pending upstream inclusion for -fno-common toolchain
    # support:
    #   https://github.com/drinkmilk/directvnc/pull/7
    (fetchpatch {
      name = "fno-common.patch";
      url = "https://github.com/drinkmilk/directvnc/commit/e9c23d049bcf31d0097348d44391fe5fd9aad12b.patch";
      sha256 = "1dnzr0dnx20w80r73j4a9n6mhbazjzlr5ps9xjj898924cg140zx";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  buildInputs = [
    directfb
    zlib
    libjpeg
    xorgproto
  ];

  meta = with lib; {
    description = "DirectFB VNC client";
    homepage = "http://drinkmilk.github.io/directvnc/";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
  };
}
