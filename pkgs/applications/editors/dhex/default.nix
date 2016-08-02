{ stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  name = "dhex-${version}";
  version = "0.68";

  src = fetchurl {
    url = "http://www.dettus.net/dhex/dhex_${version}.tar.gz";
    sha256 = "126c34745b48a07448cfe36fe5913d37ec562ad72d3f732b99bd40f761f4da08";
  };

  buildInputs = [ ncurses ];
 
  installPhase = ''
    mkdir -p $out/bin
    mkdir -p $out/share/man/man1
    mkdir -p $out/share/man/man5

    cp dhex $out/bin
    cp dhex.1 $out/share/man/man1
    cp dhexrc.5 $out/share/man/man5
    cp dhex_markers.5 $out/share/man/man5
    cp dhex_searchlog.5 $out/share/man/man5
  '';

  meta = {
    description = "A themeable hex editor with diff mode";
    homepage = http://www.dettus.net/dhex/;
    license = stdenv.lib.licenses.gpl2;
    maintainers = with stdenv.lib.maintainers; [qknight];
    platforms = with stdenv.lib.platforms; linux;
  };
}
