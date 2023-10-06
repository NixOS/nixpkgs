{ stdenv, lib, fetchurl, autoconf, automake, pkg-config, libtool
, gtk2, halibut, ncurses, perl, darwin
}:

stdenv.mkDerivation rec {
  version = "0.76";
  pname = "putty";

  src = fetchurl {
    urls = [
      "https://the.earth.li/~sgtatham/putty/${version}/${pname}-${version}.tar.gz"
      "ftp://ftp.wayne.edu/putty/putty-website-mirror/${version}/${pname}-${version}.tar.gz"
    ];
    sha256 = "0gvi8phabszqksj2by5jrjmshm7bpirhgavz0dqyz1xaimxdjz2l";
  };

  # glib-2.62 deprecations
  env.NIX_CFLAGS_COMPILE = "-DGLIB_DISABLE_DEPRECATION_WARNINGS";

  preConfigure = lib.optionalString stdenv.hostPlatform.isUnix ''
    perl mkfiles.pl
    ( cd doc ; make );
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

  nativeBuildInputs = [ autoconf automake halibut libtool perl pkg-config ];
  buildInputs = lib.optionals stdenv.hostPlatform.isUnix [
    gtk2 ncurses
  ] ++ lib.optional stdenv.isDarwin darwin.apple_sdk.libs.utmp;
  enableParallelBuilding = true;

  meta = with lib; {
    description = "A Free Telnet/SSH Client";
    longDescription = ''
      PuTTY is a free implementation of Telnet and SSH for Windows and Unix
      platforms, along with an xterm terminal emulator.
      It is written and maintained primarily by Simon Tatham.
    '';
    homepage = "https://www.chiark.greenend.org.uk/~sgtatham/putty/";
    license = licenses.mit;
    platforms = platforms.unix ++ platforms.windows;
  };
}
