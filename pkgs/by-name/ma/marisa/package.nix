{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    # https://github.com/s-yata/marisa-trie/pull/123
    (fetchpatch {
      name = "fix-binding-build.patch";
      url = "https://github.com/s-yata/marisa-trie/commit/cf4602f08df49861d987d122bd85bfdb456fe7a0.patch";
      hash = "sha256-h6+ixT63cHSpg3fhiLwJlxU296bD5YgfEaGqAHpm6+g=";
    })
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://github.com/s-yata/marisa-trie";
    changelog = "https://github.com/s-yata/marisa-trie/releases/tag/${src.tag}";
    description = "Static and space-efficient trie data structure library";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sifmelcara ];
    platforms = platforms.all;
  };
}
