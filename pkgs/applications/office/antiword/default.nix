{ fetchurl, stdenv }:

let
  name = "antiword-0.37";
in
stdenv.mkDerivation {
  inherit name;

  src = fetchurl {
    url = "http://www.winfield.demon.nl/linux/${name}.tar.gz";
    sha256 = "1b7mi1l20jhj09kyh0bq14qzz8vdhhyf35gzwsq43mn6rc7h0b4f";
  };

  prePatch = ''
    sed -i -e "s|/usr/local/bin|$out/bin|g" -e "s|/usr/share|$out/share|g" Makefile antiword.h
    substituteInPlace Makefile --replace "gcc" "cc"
  '';

  patches = [ ./10_fix_buffer_overflow_wordole_c.patch ];

  installTargets = [ "global_install" ];

  meta = {
    homepage = http://www.winfield.demon.nl/;
    description = "Convert MS Word documents to plain text or PostScript";
    license = stdenv.lib.licenses.gpl2;

    maintainers = [ stdenv.lib.maintainers.peti ];
    platforms = with stdenv.lib.platforms; linux ++ darwin;
  };
}
