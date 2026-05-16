{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation {
  pname = "miniball";
  version = "3.0";

  src = fetchurl {
    url = "https://www.inf.ethz.ch/personal/gaertner/miniball/Miniball.hpp";
    sha256 = "1piap5v8wqq0aachrq6j50qkr01gzpyndl6vf661vyykrfq0nnd2";
  };

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/include
    cp $src $out/include/miniball.hpp
  '';

  meta = {
    description = "Smallest Enclosing Balls of Points";
    homepage = "https://www.inf.ethz.ch/personal/gaertner/miniball.html";
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.erikryb ];
    platforms = lib.platforms.unix;
  };
}
