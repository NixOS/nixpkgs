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
  version = "8.3.109";

  src = fetchurl {
    url    = "http://opencircuitdesign.com/magic/archive/magic-${version}.tgz";
    sha256 = "sha256-ZK4OF5XwjW1OJmOVUFqLklfpM10eIwCILygqIyjRbEQ=";
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

  NIX_CFLAGS_COMPILE = "-Wno-implicit-function-declaration";

  patches = [
    ./0001-strip-bin-prefix.patch
    ./0002-fix-format-security.patch
  ];

  meta = with lib; {
    description = "VLSI layout tool written in Tcl";
    homepage    = "http://opencircuitdesign.com/magic/";
    license     = licenses.mit;
    maintainers = with maintainers; [ anna328p thoughtpolice AndersonTorres ];
  };
}
