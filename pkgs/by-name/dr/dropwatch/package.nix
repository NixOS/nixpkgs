{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  libbfd,
  libnl,
  libpcap,
  ncurses,
  readline,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dropwatch";
  version = "1.5.5";

  src = fetchFromGitHub {
    owner = "nhorman";
    repo = "dropwatch";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-+7bT1Gw4ncwLFkrxxbXjNs3KMM1sSQrCqXMYxKso9/4=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    libbfd
    libnl
    libpcap
    ncurses
    readline
    zlib
  ];

  enableParallelBuilding = true;

  meta = {
    description = "Linux kernel dropped packet monitor";
    homepage = "https://github.com/nhorman/dropwatch";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ c0bw3b ];
  };
})
