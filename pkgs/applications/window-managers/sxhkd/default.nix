{ stdenv, fetchurl, asciidoc, libxcb, xcbutil, xcbutilkeysyms, xcbutilwm }:

stdenv.mkDerivation rec {
  name = "sxhkd-0.5.4";
 
  src = fetchurl {
    url = "https://github.com/baskerville/sxhkd/archive/0.5.4.tar.gz";
    sha256 = "de95f97155319ded41ece9403ac9e9f18bfdd914a09f553ab09b331bbfe5d332";
  };
  
  buildInputs = [ asciidoc libxcb xcbutil xcbutilkeysyms xcbutilwm ];

  buildPhase = ''
     make PREFIX=$out
  '';

  installPhase = ''
     make PREFIX=$out install
  '';

  meta = {
    description = "Simple X hotkey daemon";
    homepage = "http://github.com/baskerville/sxhkd";
    license = "BSD";
    platforms = stdenv.lib.platforms.linux;
  };
}
