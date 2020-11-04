{ stdenv, fetchurl, m4, tcsh, libX11, tcl, tk, cairo, ncurses, mesa_glu, python3 }:

stdenv.mkDerivation {
  pname = "magic-vlsi";
  version = "8.3.5";

  src = fetchurl {
    url = "http://opencircuitdesign.com/magic/archive/magic-8.3.5.tgz";
    sha256 = "0wv4zmxlqjfaakgp802icn0cd9f8ylkz2sppix83axq8p5cg90yq";
  };

  buildInputs = [ m4 tcsh libX11 tcl tk cairo ncurses mesa_glu ];
  nativeBuildInputs = [ python3 ];

  configureFlags = [
    "--with-tcl=${tcl}"
    "--with-tk=${tk}"
    "--disable-werror"
  ];

  postPatch = ''
    patchShebangs scripts/*
  '';

  patches = [
    ./0001-strip-bin-prefix.patch
    ./0002-fix-format-security.patch
  ];

  meta = with stdenv.lib; {
    description = "VLSI layout tool written in Tcl";
    homepage = "http://opencircuitdesign.com/magic/";
    license = licenses.mit;
    maintainers = [ maintainers.anna328p ];
  };
}
