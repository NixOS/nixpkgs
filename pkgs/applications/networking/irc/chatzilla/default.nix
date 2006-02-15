{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "chatzilla-0.9.70";
  builder = ./builder.sh;
  src = fetchurl {
    url = http://rdmsoft.com/dlfs/cz/chatzilla-0.9.70-xr.zip;
    md5 = "543ab121916b8c4bfe20d4aa07536e35";
  };

  buildInputs = [unzip];
}
