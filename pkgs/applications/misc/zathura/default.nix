{ stdenv, fetchurl, pkgconfig, gtk, poppler }:
stdenv.mkDerivation rec {
  name = "zathura-0.0.5";
  src = fetchurl {
    #url = "https://pwmt.org/zathura/download/{name}.tar.gz"
    # Site's SSL cert is invalid, and I dunno how to pass --insecure to curl.
    # Thanks Mark Weber for mirroring this tarball.
    url = "http://mawercer.de/~nix/${name}.tar.gz";
    sha256 = "e4dfbcceafc7bcb5c4e1ff349822c610db6378906ab65aabba8be246d7ee9b52";
  };
  buildInputs = [ pkgconfig gtk poppler ];
  patchPhase = ''
    substituteInPlace config.mk --replace 'PREFIX = /usr' "PREFIX = $out"
  '';
  meta = {
    homepage = https://pwmt.org/zathura/;
    description = "A highly customizable and functional PDF viewer";
    longDescription = ''
      zathura is a highly customizable and functional PDF viewer based on the
      poppler rendering library and the gtk+ toolkit. The idea behind zathura
      is an application that provides a minimalistic and space saving interface
      as well as an easy usage that mainly focuses on keyboard interaction.
    '';
    license = "free";
    platforms = with stdenv.lib.platforms; linux;
  };
}
