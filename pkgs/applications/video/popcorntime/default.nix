{ lib, stdenv, fetchurl, makeWrapper, nwjs, zip }:

let
  arch = if stdenv.system == "x86_64-linux" then "64"
    else if stdenv.system == "i686-linux"   then "32" 
    else throw "Unsupported system ${stdenv.system}";

in stdenv.mkDerivation rec {
  name = "popcorntime-${version}";
  version = "0.3.9";

  src = fetchurl {
    url = "http://get.popcorntime.sh/build/Popcorn-Time-${version}-Linux-${arch}.tar.xz";
    sha256 =
      if arch == "64"
      then "0qaqdz45frgiy440jyz6hikhklx2yp08qp94z82r03dkbf4a2hvx"
      else "0y08a42pm681s97lkczdq5dblxl2jbr850hnl85hknl3ynag9kq4";
  };

  dontPatchELF = true;
  sourceRoot   = "linux${arch}";
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
