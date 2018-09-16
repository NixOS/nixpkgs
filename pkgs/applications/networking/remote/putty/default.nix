{ stdenv, lib, fetchurl, autoconf, automake, pkgconfig, libtool
, gtk2, halibut, ncurses, perl
}:

stdenv.mkDerivation rec {
  version = "0.70";
  name = "putty-${version}";

  src = fetchurl {
    urls = [
      "https://the.earth.li/~sgtatham/putty/${version}/${name}.tar.gz"
      "ftp://ftp.wayne.edu/putty/putty-website-mirror/${version}/${name}.tar.gz"
    ];
    sha256 = "1gmhwwj1y7b5hgkrkxpf4jddjpk9l5832zq5ibhsiicndsfs92mv";
  };

  preConfigure = lib.optionalString stdenv.hostPlatform.isUnix ''
    perl mkfiles.pl
    ( cd doc ; make );
    sed -e '/AM_PATH_GTK(/d' \
        -e '/AC_OUTPUT/iAM_PROG_CC_C_O' \
        -e '/AC_OUTPUT/iAM_PROG_AR' -i configure.ac
    ./mkauto.sh
    cd unix
  '' + lib.optionalString stdenv.hostPlatform.isWindows ''
    cd windows
  '';

  TOOLPATH = stdenv.cc.targetPrefix;
  makefile = if stdenv.hostPlatform.isWindows then "Makefile.mgw" else null;

  installPhase = if stdenv.hostPlatform.isWindows then ''
    for exe in *.exe; do
       install -D $exe $out/bin/$exe
    done
  '' else null;

  nativeBuildInputs = [ autoconf automake halibut libtool perl pkgconfig ];
  buildInputs = lib.optionals stdenv.hostPlatform.isUnix [
    gtk2 ncurses
  ];
  enableParallelBuilding = true;

  meta = with lib; {
    description = "A Free Telnet/SSH Client";
    longDescription = ''
      PuTTY is a free implementation of Telnet and SSH for Windows and Unix
      platforms, along with an xterm terminal emulator.
      It is written and maintained primarily by Simon Tatham.
    '';
    homepage = https://www.chiark.greenend.org.uk/~sgtatham/putty/;
    license = licenses.mit;
    platforms = platforms.unix ++ platforms.windows;
  };
}
