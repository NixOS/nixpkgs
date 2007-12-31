{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "chatzilla-0.9.79";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    # Obtained from http://chatzilla.rdmsoft.com/xulrunner/.
    url = http://chatzilla.rdmsoft.com/xulrunner/download/chatzilla-0.9.79-xr.zip;
    sha256 = "0irbi8y4y2nlbwvhmmln5h5f4wv7spd1rqg7dxg7pc93s09p5i09";
  };

  buildInputs = [unzip];

  meta = {
    homepage = http://chatzilla.hacksrus.com/;
    description = "Stand-alone version of Chatzilla, an IRC client";
  };
}
