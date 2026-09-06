{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  fuse3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "exfat";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "relan";
    repo = "exfat";
    tag = "v${finalAttrs.version}";
    hash = "sha256-5m8fiItEOO6piR132Gxq6SHOPN1rAFTuTVE+UI0V00k=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [ fuse3 ];

  outputs = [
    "out"
    "man"
  ];

  meta = {
    description = "Free exFAT file system implementation";
    homepage = "https://github.com/relan/exfat";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ dywedir ];
    platforms = lib.platforms.unix;
  };
})
