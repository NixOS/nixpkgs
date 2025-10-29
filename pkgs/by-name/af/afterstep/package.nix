{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  dbus,
  fltk13,
  gtk2,
  libICE,
  libSM,
  libtiff,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "afterstep";
  version = "2.2.12";

  src = fetchFromGitHub {
    owner = "afterstep";
    repo = "afterstep";
    rev = finalAttrs.version;
    hash = "sha256-j1ADTRZ3Mxv9VNZWhWCFMnM/CJfkphdrgbw9Ca3bBw0=";
  };

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/debian/afterstep/raw/master/debian/patches/44-Fix-build-with-gcc-5.patch";
      hash = "sha256-RNLB6PuFVA1PsYt2VwLyLyvY2OO3oIl1xk+0/6nwN+4=";
    })

    # Fix pending upstream inclusion for binutils-2.36 support:
    #  https://github.com/afterstep/afterstep/pull/7
    (fetchpatch {
      name = "binutils-2.36.patch";
      url = "https://github.com/afterstep/afterstep/commit/5e9e897cf8c455390dd6f5b27fec49707f6b9088.patch";
      hash = "sha256-aGMTyojzXEHGjO9lMT6dwLl01Fd333BUuCIX0FU9ac4=";
    })
  ];

  postPatch = ''
    # Causes fatal ldconfig cache generation attempt on non-NixOS Linux
    for mkfile in autoconf/Makefile.common.lib.in libAfter{Base,Image}/Makefile.in; do
      substituteInPlace $mkfile \
        --replace 'test -w /etc' 'false'
    done
  '';

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    dbus
    fltk13
    gtk2
    libICE
    libSM
    libtiff
  ];

  outputs = [
    "out"
    "man"
  ];

  strictDeps = true;

  # A strange type of bug: dbus is not immediately found by pkg-config
  preConfigure = ''
    # binutils 2.37 fix
    # https://github.com/afterstep/afterstep/issues/2
    fixupList=(
      "autoconf/Makefile.defines.in"
      "libAfterImage/aftershow/Makefile.in"
      "libAfterImage/apps/Makefile.in"
      "libAfterBase/Makefile.in"
      "libAfterImage/Makefile.in"
    )
    for toFix in "''${fixupList[@]}"; do
      substituteInPlace "$toFix" --replace "clq" "cq"
    done
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config dbus-1 --cflags)"
  '';

  # Parallel build fails due to missing dependencies between private libraries:
  #   ld: cannot find ../libAfterConf/libAfterConf.a: No such file or directory
  # Let's disable parallel builds until it's fixed upstream:
  #   https://github.com/afterstep/afterstep/issues/8
  enableParallelBuilding = false;

  meta = {
    homepage = "http://www.afterstep.org/";
    description = "NEXTStep-inspired window manager";
    longDescription = ''
      AfterStep is a window manager for the Unix X Window System. Originally
      based on the look and feel of the NeXTStep interface, it provides end
      users with a consistent, clean, and elegant desktop. The goal of AfterStep
      development is to provide for flexibility of desktop configuration,
      improving aestetics, and efficient use of system resources.
    '';
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    mainProgram = "afterstep";
    platforms = lib.platforms.linux;
  };
})
