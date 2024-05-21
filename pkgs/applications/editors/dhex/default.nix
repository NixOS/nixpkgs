{ lib, stdenv, fetchurl, ncurses }:

stdenv.mkDerivation rec {
  pname = "dhex";
  version = "0.69";

  src = fetchurl {
    url = "http://www.dettus.net/dhex/dhex_${version}.tar.gz";
    sha256 = "06y4lrp29f2fh303ijk1xhspa1d4x4dm6hnyw3dd8szi3k6hnwsj";
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
    homepage = "http://www.dettus.net/dhex/";
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [qknight];
    platforms = with lib.platforms; linux;
    mainProgram = "dhex";
  };
}
