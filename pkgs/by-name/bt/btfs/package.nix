{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  python3,
  boost,
  fuse3,
  libtorrent-rasterbar,
  curl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "btfs";
  version = "3.2";

  src = fetchFromGitHub {
    owner = "johang";
    repo = "btfs";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-g8ta5T17iKTpdR0wMQe1LU78LTIxwECmf86o4IlVF00=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    boost
    fuse3
    libtorrent-rasterbar
    curl
    python3
  ];

  meta = {
    description = "Bittorrent filesystem based on FUSE";
    homepage = "https://github.com/johang/btfs";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ rnhmjoj ];
    platforms = lib.platforms.unix;
  };
})
