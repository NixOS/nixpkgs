{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "chatzilla-0.9.86.1";
  
  src = fetchurl {
    # Obtained from http://chatzilla.rdmsoft.com/xulrunner/.
    url = http://chatzilla.rdmsoft.com/xulrunner/download/chatzilla-0.9.86.1-xr.zip;
    sha256 = "06s4g0x7hsckd7wr904j8rzksvqhvcrhl9zwga2458rgafcbbghd";
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
