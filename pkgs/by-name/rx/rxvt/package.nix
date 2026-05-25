{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  libtool,
  libx11,
  libxt,
  libxpm,
}:

stdenv.mkDerivation rec {
  pname = "rxvt";
  version = "2.7.10";

  src = fetchurl {
    url = "mirror://sourceforge/rxvt/${pname}-${version}.tar.gz";
    sha256 = "0jfl71gz3k7zh3kxdb8lxi06kajjnx7bq1rxjgk680l209jxask1";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libtool
    libx11
    libxt
    libxpm
  ];

  configurePhase = ''
    LIBTOOL=${libtool}/bin/libtool ./configure --prefix=$out --enable-everything --enable-smart-resize --enable-256-color
  '';

  meta = {
    homepage = "https://rxvt.sourceforge.net/";
    description = "Colour vt102 terminal emulator with less features and lower memory consumption";
    longDescription = ''
      rxvt (acronym for our extended virtual terminal) is a terminal
      emulator for the X Window System, originally written by Rob Nation
      as an extended version of the older xvt terminal by John Bovey of
      University of Kent. Mark Olesen extensively modified it later and
      took over maintenance for several years.

      rxvt is intended to be a slimmed-down alternate for xterm,
      omitting some of its little-used features, like Tektronix 4014
      emulation and toolkit-style configurability.
    '';
    maintainers = [ ];
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    knownVulnerabilities = [
      "Usage of ANSI escape sequences causes unexpected newline-termination, leading to unexpected command execution (https://www.openwall.com/lists/oss-security/2021/05/17/1)"
    ];
  };
}
