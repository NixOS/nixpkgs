{ stdenv, lib, fetchurl, fetchpatch, autoconf, automake, pkgconfig, libtool
, gtk2, halibut, ncurses, perl, darwin
}:

stdenv.mkDerivation rec {
  version = "0.71";
  pname = "putty";

  src = fetchurl {
    urls = [
      "https://the.earth.li/~sgtatham/putty/${version}/${pname}-${version}.tar.gz"
      "ftp://ftp.wayne.edu/putty/putty-website-mirror/${version}/${pname}-${version}.tar.gz"
    ];
    sha256 = "1f66iss0kqk982azmxbk4xfm2i1csby91vdvly6cr04pz3i1r4rg";
  };

  patches = [
    (fetchpatch {
      name = "CVE-2019-17069.patch";
      url = "https://git.tartarus.org/?p=simon/putty.git;a=patch;h=69201ad8936fe0ff1b8723b7a43accb5e9f1c888";
      sha256 = "1gblwc2r26ikb26b22f2r61b2lkjf80pbclfb5dhhkkqal6kbvga";
    })
  ];

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
  ] ++ lib.optional stdenv.isDarwin darwin.apple_sdk.libs.utmp;
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
