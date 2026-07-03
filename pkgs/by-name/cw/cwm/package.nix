{
  lib,
  stdenv,
  fetchFromGitHub,
  libx11,
  libxinerama,
  libxrandr,
  libxft,
  bison,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {

  pname = "cwm";
  version = "7.9";

  src = fetchFromGitHub {
    owner = "leahneukirchen";
    repo = "cwm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YC+x4YSPAgZ47PFMbzICv9ixfDxA1PG3ncLiMahSoUc=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    pkg-config
    bison
  ];
  buildInputs = [
    libx11
    libxinerama
    libxrandr
    libxft
  ];

  prePatch = ''sed -i "s@/usr/local@$out@" Makefile'';

  meta = {
    description = "Lightweight and efficient window manager for X11";
    homepage = "https://github.com/leahneukirchen/cwm";
    maintainers = with lib.maintainers; [
      _0x4A6F
      iamanaws
    ];
    license = lib.licenses.isc;
    platforms = lib.platforms.linux;
    mainProgram = "cwm";
  };
})
