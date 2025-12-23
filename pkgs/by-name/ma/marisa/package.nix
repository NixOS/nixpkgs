{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation rec {
  pname = "marisa";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "s-yata";
    repo = "marisa-trie";
    tag = "v${version}";
    hash = "sha256-+rOmbvlcEBBsjUdWRrW9WN0MfhnSe7Gm3DOXfhtcSDc=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/s-yata/marisa-trie";
    changelog = "https://github.com/s-yata/marisa-trie/releases/tag/${src.tag}";
    description = "Static and space-efficient trie data structure library";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sifmelcara ];
    platforms = lib.platforms.all;
  };
}
