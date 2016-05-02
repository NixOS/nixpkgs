{ lib, stdenv, fetchurl, makeWrapper, nwjs, zip }:

let
  arch = if stdenv.system == "x86_64-linux" then "l64"
    else if stdenv.system == "i686-linux"   then "l32" 
    else throw "Unsupported system ${stdenv.system}";

in stdenv.mkDerivation rec {
  name = "popcorntime-${version}";
  version = "0.4.0";
  build = "2";

  src = fetchurl {
    url = "http://popcorntime.ag/download.php?file=popcorn-time-community-v${version}-${build}-${arch}.tar.xz";
    sha256 =
      if arch == "l64"
      then "0a68d0a81d8e97c94afa0c75209056ee4b8486f400854c952bd3ad7251bd80c9"
      else "b311c312a29d408a7c661a271d1f3a8fc83865d8a204cf026ee87e9ac173874d";
  };

  dontPatchELF = true;
  sourceRoot = ".";
  buildInputs  = [ zip makeWrapper ];

  buildPhase = ''
    rm Popcorn-Time
    cat ${nwjs}/bin/nw nw.pak > Popcorn-Time
    chmod 555 Popcorn-Time
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -r * $out/
    makeWrapper $out/Popcorn-Time $out/bin/popcorntime
  '';

  meta = with stdenv.lib; {
    homepage = https://popcorntime.sh/;
    description = "An application that streams movies and TV shows from torrents";
    license = stdenv.lib.licenses.gpl3;
    platforms = platforms.linux;
    maintainers = with maintainers; [ bobvanderlinden rnhmjoj ];
  };
}
