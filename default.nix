{ stdenv, fetchurl, automake, unzip }:
stdenv.mkDerivation rec {
  name = "teiler-${version}";
  version = "3.1.1";
  src = fetchurl {
    url = "https://github.com/carnager/teiler/archive/v${version}.zip";
    sha256 = "0l89aaziggqg3jc7yidcj1g0y0shym5r1dvlmk0mhfwr3w76vabk";
  };
  meta = {
    homepage = https://github.com/carnager/teiler;
    description = "Little script for screenshots and screencasts utilizing rofi, maim, ffmpeg";
    license = stdenv.lib.licenses.gpl3;
  };
  dontBuild = true;
  preInstall = ''
    makeFlags="PREFIX= DESTDIR=$out"
    substituteInPlace ./teiler \
      --replace "cp /etc/teiler/teiler.conf " "cp --no-preserve=mode /etc/teiler/teiler.conf "  \
      --replace " /etc" " $out/etc"
  '';
  buildInputs = [
    unzip
  ];
}
