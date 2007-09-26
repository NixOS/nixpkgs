{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "chatzilla-0.9.78.1";
  
  builder = ./builder.sh;
  
  src = fetchurl {
    # Obtained from http://chatzilla.rdmsoft.com/xulrunner/.
    url = http://chatzilla.rdmsoft.com/xulrunner/download/chatzilla-0.9.78.1-xr.zip;
    sha256 = "1f7fgi1dvpzjsiai0vc986vd481i77hcafvnzm73bc2q8pa5g5mb";
  };

  buildInputs = [unzip];

  meta = {
    homepage = http://chatzilla.hacksrus.com/;
    description = "Stand-alone version of Chatzilla, an IRC client";
  };
}
