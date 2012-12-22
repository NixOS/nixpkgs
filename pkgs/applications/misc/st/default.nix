{ stdenv, fetchurl, libX11, ncurses, libXext, libXft }:

stdenv.mkDerivation rec {
  name = "st-0.3";
  
  src = fetchurl {
    url = "http://dl.suckless.org/st/${name}.tar.gz";
    sha256 = "0d0fjixiis4ixbz4l18rqhnssa7cy2bap3jkjyphqlqhl7lahv3d";
  };
  
  buildInputs = [ libX11 ncurses libXext libXft ];

  installPhase = ''
    TERMINFO=$out/share/terminfo make install PREFIX=$out
  '';
    
  meta = {
    homepage = http://st.suckless.org/;
    license = "MIT";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}
