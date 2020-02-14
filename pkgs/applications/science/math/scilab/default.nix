{stdenv, fetchurl, lib, gfortran
, ncurses
, withXaw3d ? false
#, withPVMlib ? false
, tcl, tk, withTk ? true
, gtk2, withGtk ? false # working ?
#, withF2c ? false
, ocaml, withOCaml ? true
#, withJava ? false
#, atlasMath, withAtlas ? false
, xlibsWrapper, withX ? true
}:

stdenv.mkDerivation rec {
  version = "4.1.2";
  pname = "scilab";
  src = fetchurl {
    url = "https://www.scilab.org/download/${version}/${pname}-${version}-src.tar.gz";
    sha256 = "1adk6jqlj7i3gjklvlf1j3il1nb22axnp4rvwl314an62siih0sc";
  };

  buildInputs = [gfortran ncurses]
  ++ lib.optionals withGtk [gtk2]
  ++ lib.optionals withOCaml [ocaml]
  ++ lib.optional withX xlibsWrapper
  ;


/*
  --with-atlas-library=DIR  Atlas library files are in DIR and we use Atlas
*/
  configureFlags = [
    # use gcc C compiler and gnu Fortran compiler (g77 or gfortran)
    "--with-gcc" "--with-g77"
    # do not compile with PVM library
    "--without-pvm"
    # compile with GTK
    (stdenv.lib.enableFeature withGtk "gtk")
    (stdenv.lib.enableFeature withGtk "gtk2")
    # compile with ocaml
    (stdenv.lib.withFeature withOCaml "ocaml")
    # do not compile Java interface
    "--without-java"
    # use the X Window System
    (stdenv.lib.withFeature withX "x")
    # compile with TCL/TK
  ] ++ lib.optionals withTk [
    "--with-tk"
    "--with-tcl-library=${tcl}/lib"
    "--with-tcl-include=${tcl}/include"
    "--with-tk-library=${tk}/lib"
    "--with-tk-include=${tk}/include"
  ]    # use Xaw3d widgets given with Scilab
    ++ lib.optional (!withXaw3d) "--with-local-xaw"
  ;

  makeFlags = [ "all" ];

  meta = {
    homepage = http://www.scilab.org/;
    description = "Scientific software package for numerical computations (Matlab lookalike)";
    # see http://www.scilab.org/legal
    license = "SciLab";
    broken = true;
  };
}
