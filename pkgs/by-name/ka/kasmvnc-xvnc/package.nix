{
  stdenv,
  lib,
  fetchFromGitHub,
  xorgserver,
  pkg-config,
  pixman,
  mesa,
  autoreconfHook,
  xorg-autoconf,
  fontutil,
  libtool,
  libX11,
  libGL,
  libgcrypt,
  xtrans,
  libxkbfile,
  libXfont2,
  libXau,
  libxcvt,
  libpciaccess,
  libepoxy,
}:
stdenv.mkDerivation rec {
  pname = "kasmvnc-xvnc";
  version = "1.3.3";
  src = fetchFromGitHub {
    owner = "kasmtech";
    repo = "KasmVNC";
    tag = "v${version}";
    hash = "sha256-1eX6ulDjYjqaZ+VXbu0ogAPpuNHW88uOCfTqKm6Qkso=";
  };

  nativeBuildInputs = [
    xorg-autoconf
    pkg-config
    autoreconfHook
  ];

  buildInputs = [
    fontutil
    libtool
    libX11
    libGL
    libgcrypt
    xtrans
    libxkbfile
    libXfont2
    libXau
    libxcvt
    libpciaccess
    libepoxy
    mesa
    pixman
  ];

  xorgSource = xorgserver.src;

  patchPhase = ''
    cp -R ${src}/unix/xserver unix/
    tar -xf ${xorgSource} -C unix/xserver --strip-components=1
    cd unix/xserver/

    # kasmvnc xvnc requires patches to be applied. Though newer versions do not seem to have / need patches?
    # Once this properly runs, please re-check if this is needed.
    #patch -p1 < ${src}/unix/xserver120.patch
  '';

  configureFlags = [
    (lib.strings.enableFeature true "static")
    (lib.strings.enableFeature true "xorg")
  ];

  makeFlags = [
    "KASMVNC_SRCDIR=${src}"
  ];

  installFlags = [
    "DESTDIR=$(out)"
  ];

  strictDeps = true;
}

