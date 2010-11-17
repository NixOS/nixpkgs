{ stdenv, fetchsvn, ncurses, gtk, pkgconfig, autoconf, automake, perl, halibut }:
 
let
  rev = 8934;
in
stdenv.mkDerivation {
  name = "putty-${toString rev}";
  # builder = ./builder.sh;

  preConfigure = ''
    perl mkfiles.pl
    ( cd doc ; make );
    cd unix
    sed '/AM_PATH_GTK(/d' -i configure.ac
    cp ${automake}/share/automake-*/install-sh .
    autoreconf -vf
  '';
  
  # The hash is going to change on new snapshot.
  # I don't know of any better URL
  src = fetchsvn {
    url = svn://svn.tartarus.org/sgt/putty;
    rev = rev;
    sha256 = "f5d9870dde7166afd277f7501914c6515b35ee7bb42965ccd22fe977ee5d1b0d";
  };

  buildInputs = [ gtk ncurses pkgconfig autoconf automake perl halibut ];
}
