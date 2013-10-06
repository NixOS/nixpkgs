{ stdenv, fetchurl, writeText, libX11, ncurses, libXext, libXft, fontconfig
, conf? null}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "st-0.4.1";
  
  src = fetchurl {
    url = "http://dl.suckless.org/st/${name}.tar.gz";
    sha256 = "0cdzwbm5fxrwz8ryxkh90d3vwx54wjyywgj28ymsb5fdv3396bzf";
  };

  configFile = optionalString (conf!=null) (writeText "config.def.h" conf);
  preBuild = optionalString (conf!=null) "cp ${configFile} config.def.h";
  
  buildInputs = [ libX11 ncurses libXext libXft fontconfig ];

  NIX_LDFLAGS = "-lfontconfig";

  installPhase = ''
    TERMINFO=$out/share/terminfo make install PREFIX=$out
  '';
    
  meta = {
    homepage = http://st.suckless.org/;
    license = "MIT";
    maintainers = with maintainers; [viric];
    platforms = with platforms; linux;
  };
}
