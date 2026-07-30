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
  version = "3.1";

  src = fetchFromGitHub {
    owner = "johang";
    repo = "btfs";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-JuofC4TpbZ56qiUrHeoK607YHVbwqwLGMIdUpsTm9Ic=";
  };

  patches = [
    # https://github.com/johang/btfs/pull/103
    ./disable-macfuse-extensions.patch
  ];

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
