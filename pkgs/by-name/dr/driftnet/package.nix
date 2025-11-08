{
  lib,
  stdenv,
  autoreconfHook,
  cairo,
  fetchFromGitHub,
  giflib,
  glib,
  gtk3,
  libjpeg,
  libpcap,
  libpng,
  libuv,
  libwebsockets,
  libwebp,
  openssl,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "driftnet";
  version = "1.6.0";

  src = fetchFromGitHub {
    owner = "deiv";
    repo = "driftnet";
    tag = "v${version}";
    hash = "sha256-f7EPC/n3CyxVOXC6j43Nnwkgu/aDVst8lQpzfgegDsI=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    cairo
    giflib
    glib
    gtk3
    libjpeg
    libpcap
    libpng
    libuv
    libwebsockets
    libwebp
    openssl
  ];

  meta = {
    description = "Watches network traffic, and picks out and displays JPEG and GIF images for display";
    homepage = "https://github.com/deiv/driftnet";
    changelog = "https://github.com/deiv/driftnet/releases/tag/v${version}";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ offline ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    mainProgram = "driftnet";
  };
}
