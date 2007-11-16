{stdenv, fetchurl}:

stdenv.mkDerivation {
  name = "lame-3.97";
  src = fetchurl {
    url = mirror://sourceforge/lame/lame-3.97.tar.gz ;
	sha256 = "05xy9lv6m9s013lzlvhxwvr1586c239xaiiwka52k18hs6k388qa";
  };
}
