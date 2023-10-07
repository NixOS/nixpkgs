{ lib, fetchurl, stdenv }:

stdenv.mkDerivation rec{
  pname = "antiword";
  version = "0.37";

  src = fetchurl {
    url = "http://www.winfield.demon.nl/linux/antiword-${version}.tar.gz";
    sha256 = "1b7mi1l20jhj09kyh0bq14qzz8vdhhyf35gzwsq43mn6rc7h0b4f";
  };

  prePatch = ''
    sed -i -e "s|/usr/local/bin|$out/bin|g" -e "s|/usr/share|$out/share|g" Makefile antiword.h
    substituteInPlace Makefile --replace "gcc" '$(CC)'
  '';

  patches = [ ./10_fix_buffer_overflow_wordole_c_CVE-2014-8123.patch ];

  makeFlags = [
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  installTargets = [ "global_install" ];

  meta = {
    homepage = "http://www.winfield.demon.nl/";
    description = "Convert MS Word documents to plain text or PostScript";
    license = lib.licenses.gpl2;

    platforms = with lib.platforms; linux ++ darwin;
  };
}
