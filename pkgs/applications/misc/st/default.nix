{ stdenv, fetchurl, pkgconfig, writeText, libX11, ncurses, libXext, libXft, fontconfig
, conf? null}:

with stdenv.lib;

stdenv.mkDerivation rec {
  name = "st-0.5";
  
  src = fetchurl {
    url = "http://dl.suckless.org/st/${name}.tar.gz";
    sha256 = "0knxpzaa86pprng6hak8hx8bw22yw22rpz1ffxjpcvqlz3xdv05f";
  };

  configFile = optionalString (conf!=null) (writeText "config.def.h" conf);
  preBuild = optionalString (conf!=null) "cp ${configFile} config.def.h";
  
  buildInputs = [ pkgconfig libX11 ncurses libXext libXft fontconfig ];

  NIX_LDFLAGS = "-lfontconfig";

  installPhase = ''
    TERMINFO=$out/share/terminfo make install PREFIX=$out
  '';
    
  meta = {
    homepage = http://st.suckless.org/;
    license = stdenv.lib.licenses.mit;
    maintainers = with maintainers; [viric];
    platforms = with platforms; linux;
  };
}
