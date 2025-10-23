{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "aalib";
  version = "1.4rc5";

  src = fetchurl {
    url = "mirror://sourceforge/aa-project/aalib-${version}.tar.gz";
    sha256 = "1vkh19gb76agvh4h87ysbrgy82hrw88lnsvhynjf4vng629dmpgv";
  };

  outputs = [
    "bin"
    "dev"
    "out"
    "man"
    "info"
  ];
  setOutputFlags = false; # Doesn't support all the flags

  patches = [
    # Fix implicit `int` on `main` error with newer versions of clang
    ./clang.patch
    # Fix build against opaque aalib API
    ./ncurses-6.5.patch
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ ./darwin.patch ];

  # The fuloong2f is not supported by aalib still
  preConfigure = ''
    configureFlagsArray+=(
      "--bindir=$bin/bin"
      "--includedir=$dev/include"
      "--libdir=$out/lib"
    )
  '';

  buildInputs = [ ncurses ];

  configureFlags = [
    "--without-x"
    "--with-ncurses=${ncurses.dev}"
  ];

  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  };

  postInstall = ''
    mkdir -p $dev/bin
    mv $bin/bin/aalib-config $dev/bin/aalib-config
    substituteInPlace $out/lib/libaa.la --replace "${ncurses.dev}/lib" "${ncurses.out}/lib"
  '';

  meta = {
    description = "ASCII art graphics library";
    platforms = lib.platforms.unix;
    license = lib.licenses.lgpl2;
  };
}
