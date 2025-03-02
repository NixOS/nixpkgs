{ lib, stdenv
, fetchurl
, python3
, m4
, cairo
, libX11
, mesa_glu
, ncurses
, tcl
, tcsh
, tk
}:

stdenv.mkDerivation rec {
  pname = "magic-vlsi";
  version = "8.3.517";

  src = fetchurl {
    url    = "http://opencircuitdesign.com/magic/archive/magic-${version}.tgz";
    sha256 = "sha256-WXvEq3/Qw2UCTtph/r6dQ5xafqASHrAuLzfcXW3Sa7E=";
  };

  nativeBuildInputs = [ python3 ];
  buildInputs = [
    cairo
    libX11
    m4
    mesa_glu
    ncurses
    tcl
    tcsh
    tk
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-tcl=${tcl}"
    "--with-tk=${tk}"
    "--disable-werror"
  ];

  postPatch = ''
    patchShebangs scripts/*
  '';

  env.NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration";

  meta = with lib; {
    description = "VLSI layout tool written in Tcl";
    homepage    = "http://opencircuitdesign.com/magic/";
    license     = licenses.mit;
    maintainers = with maintainers; [ thoughtpolice ];
  };
}
