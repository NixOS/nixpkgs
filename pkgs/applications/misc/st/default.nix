{ stdenv, fetchurl, libX11, ncurses}:

stdenv.mkDerivation rec {
  name = "st-0.2.1";
  
  src = fetchurl {
    url = http://hg.suckless.org/st/archive/0.2.1.tar.gz;
    sha256 = "15yqyys69ifjc4vrzvamrg7x0pwa60mnjpi0kap4y9ykhds83xab";
  };
  
  buildInputs = [ libX11 ncurses ];

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
