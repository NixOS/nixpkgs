{ stdenv, fetchurl, ncurses
, gtk
}:
 
stdenv.mkDerivation {
  name = "putty-0.60";
  builder = ./builder.sh;
  
  src = fetchurl {
    url = http://the.earth.li/~sgtatham/putty/latest/putty-0.60.tar.gz;
    sha256 = "b2bbaaf9324997e85cf15d44ed41e8e89539c8215dceac9d6d7272a37dbc2849";
  };

  buildInputs = [
   gtk ncurses
  ];

  #propagatedBuildInputs = [
  #];

  inherit gtk;
}
