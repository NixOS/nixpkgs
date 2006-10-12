{stdenv, fetchurl, unzip}:

stdenv.mkDerivation {
  name = "chatzilla-0.9.74";
  builder = ./builder.sh;
  src = fetchurl {
    # Obtained from http://chatzilla.rdmsoft.com/xulrunner/.
    url = http://nix.cs.uu.nl/dist/tarballs/chatzilla-0.9.74-xr.zip;
    md5 = "a1eada15b172eab6a771afa5f8670f7a";
  };

  buildInputs = [unzip];

  meta = {
    description = "Stand-alone version of Chatzilla, an IRC client";
  };
}
