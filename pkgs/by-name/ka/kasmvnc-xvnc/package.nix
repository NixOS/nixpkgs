{
  stdenv,
  fetchFromGitHub,
  xorgserver,
  pkg-config,
  pixman,
  mesa,
  autoconf,
  automake,
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
    rev = "v${version}";
    hash = "sha256-1eX6ulDjYjqaZ+VXbu0ogAPpuNHW88uOCfTqKm6Qkso=";
  };

  nativeBuildInputs = [
    autoconf
    automake
    xorg-autoconf
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
    pkg-config
    pixman
  ];

  buildInputs = [
    #libXfont2
    #libX11
    #libXau
    #libXdmcp
    #libXext
    #libXfixes
    #libXfont2
    #xorgproto
    #fontconfig
    #freetype
    #libXfont2
    #xkeyboard_config
    #libxkbfile
    #libpciaccess
    #xorgserver
  ];

  xorgSource = xorgserver.src;

  patchPhase = ''
    mkdir -p unix/xserver
    cp -R ${src}/unix/xserver unix/
    tar -xf ${xorgSource} -C unix/xserver --strip-components=1
    cd unix/xserver/
    #patch -p1 < ${src}/unix/xserver120.patch
    autoreconf -fiv
    ls -al
  '';

  configureFlags = [
    "--with-pic"
    "--without-dtrace"
    "--enable-static"
    "--disable-dri"
    "--disable-xinerama"
    "--disable-xvfb"
    "--disable-xnest"
    "--enable-xorg"
    "--disable-dmx"
    "--disable-xwin"
    "--disable-xephyr"
    "--disable-kdrive"
    "--disable-config-dbus"
    "--disable-config-hal"
    "--disable-config-udev"
    "--disable-dri2"
    "--enable-install-libxf86config"
    "--enable-glx"
    "--with-default-font-path=catalogue:/etc/X11/fontpath.d,built-ins"
    "--with-fontdir=/usr/share/X11/fonts"
    "--with-xkb-path=/usr/share/X11/xkb"
    "--with-xkb-output=/var/lib/xkb"
    "--with-xkb-bin-directory=/usr/bin"
    "--with-serverconfig-path=/usr/lib/xorg"
    "--with-dri-driver-path=/usr/lib/dri"
  ];

  configureScript = "./configure";

  buildPhase = ''
    runHook preBuild
    make KASMVNC_SRCDIR=${src}
  '';

  installPhase = ''
    mkdir -p $out
    make install DESTDIR=$out
  '';
}

