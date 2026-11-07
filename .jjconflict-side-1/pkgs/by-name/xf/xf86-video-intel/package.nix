{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  dri-pkgconfig-stub,
  libdrm,
  libpciaccess,
  libpng,
  libx11,
  libxcb,
  libxcb-util,
  libxcursor,
  libxdamage,
  libxfixes,
  libxinerama,
  libxrandr,
  libxrender,
  libxscrnsaver,
  libxshmfence,
  libxtst,
  libxv,
  libxvmc,
  libxxf86vm,
  pixman,
  valgrind,
  xorgproto,
  xorg-server,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "xf86-video-intel";
  version = "unstable-2025-03-21";

  src = fetchFromGitLab {
    domain = "gitlab.freedesktop.org";
    group = "xorg";
    owner = "driver";
    repo = "xf86-video-intel";
    rev = "4a64400ec6a7d8c0aba0e6a39b16a5e86d0af843";
    hash = "sha256-bwyNVHSTnbyxU6059nITk4TNBEly39xPB67gGOPkmYU=";
  };

  patches = [
    # Comment from 037167ae17fefe6b5dc86dc05f0dd168031c3c68:
    #
    # The i965 driver was removed in Mesa 22, but the xf86-video-intel driver
    # hasn't been updated to reflect this. This leads to the following error
    # when used with the affected hardware:
    #
    # (EE) AIGLX error: dlopen of /run/opengl-driver/lib/dri/i965_dri.so failed
    #                   (/run/opengl-driver/lib/dri/i965_dri.so: cannot open
    #                   shared object file: No such file or directory)
    # (EE) AIGLX error: unable to load driver i965
    ./use_crocus_and_iris.patch
  ];

  strictDeps = true;

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
  ];

  buildInputs = [
    dri-pkgconfig-stub
    libdrm
    libpciaccess
    libpng
    libx11
    libxcb
    libxcb-util
    libxcursor
    libxdamage
    libxfixes
    libxinerama
    libxrandr
    libxrender
    libxscrnsaver
    libxshmfence
    libxtst
    libxv
    libxvmc
    libxxf86vm
    pixman
    valgrind
    xorgproto
    xorg-server
  ];

  configureFlags = [
    "--with-default-dri=3"
    "--enable-tools"
  ];

  meta = {
    description = "Open-source Xorg graphics driver for Intel graphics";
    homepage = "https://gitlab.freedesktop.org/xorg/driver/xf86-video-intel";
    license = with lib.licenses; [
      mit
      hpndSellVariant
    ];
    maintainers = [ ];
    platforms = [
      "i686-linux"
      "x86_64-linux"
    ];
  };
})
