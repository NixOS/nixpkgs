{ stdenv, fetchsvn, ncurses, gtk, pkgconfig, autoconf, automake, perl, halibut
, libtool }:
 
let
  rev = 9690;
in
stdenv.mkDerivation {
  name = "putty-${toString rev}";
  # builder = ./builder.sh;

  preConfigure = ''
    perl mkfiles.pl
    ( cd doc ; make );
    sed '/AM_PATH_GTK(/d' -i unix/configure.ac
    sed '/AC_OUTPUT/iAM_PROG_CC_C_O' -i unix/configure.ac
    sed '/AC_OUTPUT/iAM_PROG_AR' -i unix/configure.ac
    ./mkauto.sh
    cd unix
  '';
  
  # The hash is going to change on new snapshot.
  # I don't know of any better URL
  src = fetchsvn {
    url = svn://svn.tartarus.org/sgt/putty;
    rev = rev;
    sha256 = "e1fb49766e0724a12776ec3d6cd0bd420e03ebdc3383a01a12dbfd30983f81ef";
  };

  buildInputs = [ gtk ncurses pkgconfig autoconf automake perl halibut libtool ];
}
