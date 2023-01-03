{ lib
, stdenv
, fetchurl
, fetchpatch
, autoreconfHook
, curl
, libjpeg
, libpng
, lirc
, ncurses
, pkg-config
, readline
, shared-mime-info
, xine-lib
, xorg
}:

stdenv.mkDerivation rec {
  pname = "xine-ui";
  version = "0.99.13";

  src = fetchurl {
    url = "mirror://sourceforge/xine/${pname}-${version}.tar.xz";
    sha256 = "sha256-sjgtB1xysbEAOeDpAxDMhsjZEDWMU1We2C09WEIB9cU=";
  };

  patches = [
    (fetchpatch {
      # Fix build on aarch64
      name = "xine-ui_FTBS_aarch64.patch";
      url = "https://salsa.debian.org/debian/xine-ui/-/raw/b2f04f64947a8975a805950e7e67b15cb44007ef/debian/patches/backport/0003-Fix-build.patch";
      sha256 = "03f8nkm7q11v5vssl1bj500ja4ljz4y752mfk22k2g4djkwimx62";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    shared-mime-info
  ];
  buildInputs = [
    curl
    libjpeg
    libpng
    lirc
    ncurses
    readline
    xine-lib
  ] ++ (with xorg; [
    libXext
    libXft
    libXi
    libXinerama
    libXtst
    libXv
    libXxf86vm
    xorgproto
  ]);

  configureFlags = [ "--with-readline=${readline.dev}" ];

  LIRC_CFLAGS="-I${lirc}/include";
  LIRC_LIBS="-L ${lirc}/lib -llirc_client";

  postInstall = ''
    substituteInPlace $out/share/applications/xine.desktop \
      --replace "MimeType=;" "MimeType="
  '';

  meta = with lib; {
    homepage = "http://xine.sourceforge.net/";
    description = "Xlib-based frontend for Xine video player";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = platforms.linux;
  };
}
