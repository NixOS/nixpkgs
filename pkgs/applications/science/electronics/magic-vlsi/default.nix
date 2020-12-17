{ stdenv, fetchurl
, m4, tcsh, libX11, tcl, tk
, cairo, ncurses, mesa_glu, python3
}:

stdenv.mkDerivation rec {
  pname = "magic-vlsi";
  version = "8.3.80";

  src = fetchurl {
    url    = "http://opencircuitdesign.com/magic/archive/magic-${version}.tgz";
    sha256 = "0a5x4sh5xsr79pqbgv6221jc4fvaxkg2pvrdhy1cs4bmsc1sbm9j";
  };

  buildInputs = [ m4 tcsh libX11 tcl tk cairo ncurses mesa_glu ];
  nativeBuildInputs = [ python3 ];
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

  meta = with stdenv.lib; {
    description = "VLSI layout tool written in Tcl";
    homepage    = "http://opencircuitdesign.com/magic/";
    license     = licenses.mit;
    maintainers = with maintainers; [ anna328p thoughtpolice ];
  };
}
