{ lib, stdenv, pkg-config, fetchFromGitHub, opencv2, ncurses, portaudio }:

stdenv.mkDerivation {
  pname = "p2pvc";
  version = "unstable-2015-02-12";

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [ opencv2 ncurses portaudio ];

  enableParallelBuilding = true;

  installPhase = "mkdir -p $out/bin; cp p2pvc $out/bin/";

  src = fetchFromGitHub {
    owner = "mofarrell";
    repo = "p2pvc";
    rev = "d7b1c70288a7750fc8f9a22dbddbe51d34b5b9e5";
    sha256 = "0d4vvrsjad5gk4rrjwgydn9ffj12jfb4aksw2px6jw75hp9pzmka";
  };

  meta = {
    description = "Point to point color terminal video chat";
    homepage = "https://github.com/mofarrell/p2pvc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ trino ];
    platforms = with lib.platforms; linux;
    mainProgram = "p2pvc";
  };
}
