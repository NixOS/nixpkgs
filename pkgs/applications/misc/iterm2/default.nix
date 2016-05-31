{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "iterm2-${version}";
  version = "2.1.4";

  src = fetchurl {
    url = "https://iterm2.com/downloads/stable/iTerm2-2_1_4.zip";
    sha256 = "1kb4j1p1kxj9dcsd34709bm2870ffzpq6jig6q9ixp08g0zbhqhh";
  };

  buildInputs = [ unzip ];
  installPhase = ''
    mkdir -p "$out/Applications"
    mv "$(pwd)" "$out/Applications/iTerm.app"
  '';

  meta = {
    description = "A replacement for Terminal and the successor to iTerm";
    homepage = https://www.iterm2.com/;
    license = stdenv.lib.licenses.gpl2;
    platforms = stdenv.lib.platforms.darwin;
  };
}
