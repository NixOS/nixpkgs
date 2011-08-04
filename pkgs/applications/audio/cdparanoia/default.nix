{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "cdparanoia-III-10.2";
  
  src = fetchurl {
    url = "http://downloads.xiph.org/releases/cdparanoia/${name}.src.tgz";
    sha256 = "1pv4zrajm46za0f6lv162iqffih57a8ly4pc69f7y0gfyigb8p80";
  };
  
  meta = {
    homepage = http://xiph.org/paranoia;
    description = "A tool and library for reading digital audio from CDs";
  };
}
