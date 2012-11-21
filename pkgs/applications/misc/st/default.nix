{ stdenv, fetchurl, libX11, ncurses, libXext, libXft }:

stdenv.mkDerivation rec {
  name = "st-0.3";
  
  src = fetchurl {
    url = http://hg.suckless.org/st/archive/0.3.tar.gz;
    sha256 = "12ypldjjpsq3nvhszgjsk4wgqkwcvz06qiqw8k5npv3rd1nbx9cl";
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
