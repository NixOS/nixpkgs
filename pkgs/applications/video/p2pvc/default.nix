{ stdenv, pkgconfig, fetchFromGitHub, opencv, ncurses, portaudio }:

stdenv.mkDerivation {
  name = "p2pvc";

  buildInputs = [ pkgconfig opencv ncurses portaudio ];

  enableParallelBuilding = true;

  installPhase = "mkdir -p $out/bin; cp p2pvc $out/bin/";

  src = fetchFromGitHub {
    owner = "mofarrell";
    repo = "p2pvc";
    rev = "d7b1c70288a7750fc8f9a22dbddbe51d34b5b9e5";
    sha256 = "0d4vvrsjad5gk4rrjwgydn9ffj12jfb4aksw2px6jw75hp9pzmka";
  };

  meta = {
    description = "A point to point color terminal video chat";
    homepage = https://github.com/mofarrell/p2pvc;
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [ trino ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
