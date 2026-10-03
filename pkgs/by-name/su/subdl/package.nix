{
  lib,
  stdenv,
  fetchFromGitHub,
  python3,
}:

stdenv.mkDerivation {
  pname = "subdl";
  version = "0-unstable-2017-11-06";

  src = fetchFromGitHub {
    owner = "alexanderwink";
    repo = "subdl";
    rev = "4cf5789b11f0ff3f863b704b336190bf968cd471";
    hash = "sha256-yLpxfp+/9Ha9rJO3DfCE3/J5zBFabQo4JzgRGSYrs04=";
  };

  buildInputs = [ python3 ];

  installPhase = ''
    install -vD subdl $out/bin/subdl
  '';

  meta = {
    homepage = "https://github.com/alexanderwink/subdl";
    description = "Command-line tool to download subtitles from opensubtitles.org";
    platforms = lib.platforms.all;
    license = lib.licenses.gpl3;
    maintainers = [ lib.maintainers.exfalso ];
    mainProgram = "subdl";
  };
}
