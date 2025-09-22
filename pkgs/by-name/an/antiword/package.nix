{
  lib,
  fetchurl,
  stdenv,
}:

stdenv.mkDerivation rec {
  pname = "antiword";
  version = "0.37";

  src = fetchurl {
    url = "https://web.archive.org/web/20221117105329if_/http://www.winfield.demon.nl/linux/antiword-${version}.tar.gz";
    hash = "sha256-jiwAD8vG1kGw5v+V4TyEbaP/MQl4AehnAhJKIGiI9aw=";
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
