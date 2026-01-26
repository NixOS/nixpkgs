{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  fuse,
}:

stdenv.mkDerivation rec {
  pname = "exfat";
  version = "1.4.0";

  src = fetchFromGitHub {
    owner = "relan";
    repo = "exfat";
    rev = "v${version}";
    sha256 = "sha256-5m8fiItEOO6piR132Gxq6SHOPN1rAFTuTVE+UI0V00k=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [ fuse ];

  outputs = [
    "out"
    "man"
  ];

  meta = {
    description = "Free exFAT file system implementation";
    inherit (src.meta) homepage;
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ dywedir ];
    platforms = lib.platforms.unix;
  };
}
