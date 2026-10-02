{
  lib,
  stdenv,
  fetchurl,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aalib";
  version = "1.4rc5";
  __structuredAttrs = true;
  strictDeps = true;

  src = fetchurl {
    url = "mirror://sourceforge/aa-project/aalib-${finalAttrs.version}.tar.gz";
    hash = "sha256-+93akjDPbuKk9XBrSxHiGQrkX17aHwQJ3E+Zs14KcO4=";
  };

  patches = [
    # Fix implicit `int` on `main` error with newer versions of clang
    ./clang.patch
    # Fix build against opaque aalib API
    ./ncurses-6.5.patch
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ ./darwin.patch ];

  outputs = [
    "bin"
    "dev"
    "out"
    "man"
    "info"
  ];

  buildInputs = [ ncurses ];

  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-Wno-error=implicit-function-declaration";
  };

  preConfigure =
    # The configure script does the correct thing when 'system' is already set
    # Export it explicitly for __structuredAttrs.
    ''
      export system
    ''
    # There is a check for linux-gnu on POWER that disables shared library creation if /lib/ld.so.1 doesn't exists
    # (which it never does for us), because it assumes that it is then running on / targeting MkLinux, which supposedly
    # didn't support shared libraries.
    # MkLinux is discontinued, regular Linux supports POWER now. Delete the case and allow shared libraries to be made.
    + ''
      substituteInPlace ltconfig \
        --replace-fail 'powerpc*) dynamic_linker=no ;;' ""
    '';

  setOutputFlags = false; # Doesn't support all the flags
  configureFlags = [
    "--without-x"
    "--with-ncurses=${ncurses.dev}"

    # set output flags manually
    "--bindir=${placeholder "bin"}/bin"
    "--includedir=${placeholder "dev"}/include"
    "--libdir=${placeholder "out"}/lib"
  ];

  postInstall = ''
    mkdir -p $dev/bin
    mv $bin/bin/aalib-config $dev/bin/aalib-config
    substituteInPlace $out/lib/libaa.la --replace-fail "${ncurses.dev}/lib" "${ncurses.out}/lib"
  '';

  meta = {
    description = "ASCII art graphics library";
    homepage = "https://aa-project.sourceforge.net/aalib";
    license = lib.licenses.lgpl2Plus; # multiple files have LGPL header with the "any later version"
    maintainers = [ lib.maintainers.quantenzitrone ];
    platforms = lib.platforms.unix;
  };
})
