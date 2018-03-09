{ stdenv, fetchurl, xorg, x11 }:

stdenv.mkDerivation rec {
  version = "1.2.sakura.5";
  vname = "2.0b";
  name = "oneko-${vname}";
  src = fetchurl {
    url = "http://www.daidouji.com/oneko/distfiles/oneko-${version}.tar.gz";
    sha256 = "0bxjlbafn10sfi5d06420pg70rpvsiy5gdbm8kspd6qy4kqhabic";
  };
  buildInputs = [ xorg.imake xorg.gccmakedep x11 ];
  
  configurePhase = "xmkmf";

  installPhase = ''
    make install BINDIR=$out/bin
    make install.man MANPATH=$out/share/man
  '';

  meta = with stdenv.lib; {
    description = "Creates a cute cat chasing around your mouse cursor";
    longDescription = ''
    Oneko changes your mouse cursor into a mouse
    and creates a little cute cat, which starts
    chasing around your mouse cursor.
    When the cat is done catching the mouse, it starts sleeping.
    '';
    homepage = "http://www.daidouji.com/oneko/";
    license = licenses.publicDomain;
    maintainers = [ maintainers.xaverdh ];
    platforms = platforms.linux;
  };
}

