{ lib, stdenv, fetchurl, pkg-config
, libtiff
, fltk, gtk
, libICE, libSM
, dbus
, fetchpatch
}:

stdenv.mkDerivation rec {

  pname = "afterstep";
  version = "2.2.12";
  sourceName = "AfterStep-${version}";

  src = fetchurl {
    urls = [ "ftp://ftp.afterstep.org/stable/${sourceName}.tar.bz2" ];
    sha256 = "1j7vkx1ig4kzwffdxnkqv3kld9qi3sam4w2nhq18waqjsi8xl5gz";
  };

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/debian/afterstep/raw/master/debian/patches/44-Fix-build-with-gcc-5.patch";
      sha256 = "1vipy2lzzd2gqrsqk85pwgcdhargy815fxlbn57hsm45zglc3lj4";
    })

    # Fix pending upstream inclusion for binutils-2.36 support:
    #  https://github.com/afterstep/afterstep/pull/7
    (fetchpatch {
      name = "binutils-2.36.patch";
      url = "https://github.com/afterstep/afterstep/commit/5e9e897cf8c455390dd6f5b27fec49707f6b9088.patch";
      sha256 = "1kk97max05r2p1a71pvpaza79ff0klz32rggik342p7ki3516qv8";
    })
  ];

  postPatch = ''
    # Causes fatal ldconfig cache generation attempt on non-NixOS Linux
    for mkfile in autoconf/Makefile.common.lib.in libAfter{Base,Image}/Makefile.in; do
      substituteInPlace $mkfile \
        --replace 'test -w /etc' 'false'
    done
  '';

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ libtiff fltk gtk libICE libSM dbus ];

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

  meta = with lib; {
    description = "A NEXTStep-inspired window manager";
    longDescription = ''
      AfterStep is a window manager for the Unix X Window
      System. Originally based on the look and feel of the NeXTStep
      interface, it provides end users with a consistent, clean, and
      elegant desktop. The goal of AfterStep development is to provide
      for flexibility of desktop configuration, improving aestetics,
      and efficient use of system resources.
    '';
    homepage = "http://www.afterstep.org/";
    license = licenses.gpl2;
    maintainers = [ maintainers.AndersonTorres ];
    platforms = platforms.linux;
  };

}
