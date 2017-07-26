{ stdenv, fetchFromGitHub, libX11, libXext, libjpeg, libpng, giflib }:

stdenv.mkDerivation rec {
  name = "meh-unstable-2015-04-11";

  src = fetchFromGitHub {
    owner = "jhawthorn";
    repo = "meh";
    rev = "4ab1c75f97cb70543db388b3ed99bcfb7e94c758";
    sha256 = "1j1n3m9hjhz4faryai97jq7cr6a322cqrd878gpkm9nrikap3bkk";
  };

  installPhase = ''
    make PREFIX=$out install
  '';

  outputs = [ "out" "doc" ];

  buildInputs = [ libXext libX11 libjpeg libpng giflib ];

  meta = {
    description = "A minimal image viewer using raw XLib";
    homepage = http://www.johnhawthorn.com/meh/;
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.linux;
  };
}
