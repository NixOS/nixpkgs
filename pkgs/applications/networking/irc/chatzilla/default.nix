{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "chatzilla-0.9.86";
  
  src = fetchurl {
    # Obtained from http://chatzilla.rdmsoft.com/xulrunner/.
    url = http://chatzilla.rdmsoft.com/xulrunner/download/chatzilla-0.9.86-xr.zip;
    sha256 = "1z8767arx2ncch0pzkdzhisjgmd45qianahz3xr8isvahv2klj5x";
  };

  buildInputs = [ unzip ];

  buildCommand = ''
    ensureDir $out
    unzip $src -d $out
  '';

  meta = {
    homepage = http://chatzilla.hacksrus.com/;
    description = "Stand-alone version of Chatzilla, an IRC client";
  };
}
