{stdenv, fetchurl, lib, gfortran
, ncurses
, Xaw3d, withXaw3d ? false
#, withPVMlib ? false
, tcl, tk, withTk ? false
, gtk, withGtk ? false # working ?
#, withF2c ? false
, ocaml, withOCaml ? false
#, withJava ? false
#, atlasMath, withAtlas ? false
, x11, withX ? false
}:

stdenv.mkDerivation rec {
  version = "4.1.2";
  name = "scilab-${version}";
  src = fetchurl {
    url = "http://www.scilab.org/download/${version}/${name}-src.tar.gz";
    # md5 coming from http://www.scilab.org/download/index_download.php
    md5 = "17a7a6aa52918f33d96777a0dc423658";
  };

  buildInputs = [gfortran ncurses]
  ++ lib.optionals withGtk [gtk]
  ++ lib.optionals withOCaml [ocaml]
  ++ lib.optionals withX [x11]
  ;


/*
  --with-atlas-library=DIR  Atlas library files are in DIR and we use Atlas
*/
  configureFlags = ""
  # use gcc C compiler and gnu Fortran compiler (g77 or gfortran)
  + " --with-gcc --with-g77"
  # use Xaw3d widgets given with Scilab
  + (lib.optionalString (!withXaw3d) " --with-local-xaw")
  # do not compile with PVM library
  + " --without-pvm"
  # compile with GTK
  + (if withGtk then "
       --with-gtk --with-gtk2
    " else "
       --without-gtk --without-gtk2
    ")
  # compile with TCL/TK
  + (lib.optionalString withTk "
       --with-tk
       --with-tcl-library=${tcl}/lib
       --with-tcl-include=${tcl}/include
       --with-tk-library=${tk}/lib
       --with-tk-include=${tk}/include
    ")
  # do not use Gtk widgets
  + " --without-gtk --without-gtk2"
  # compile with ocaml
  + (if withOCaml then " --with-ocaml" else " --without-ocaml")
  # do not compile Java interface
  + " --without-java"
  # use the X Window System
  + (lib.optionalString withX "
      --with-x
      --x-libraries=${x11}/lib
      --x-includes=${x11}/include
    ")
  ;

  makeFlags = "all";

  meta = {
    homepage = http://www.scilab.org/;
    description = "Scientific software package for numerical computations (Matlab lookalike)";
    # see http://www.scilab.org/legal
    license = "SciLab";
  };
}
