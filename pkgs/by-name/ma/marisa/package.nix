{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "marisa";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "s-yata";
    repo = "marisa-trie";
    tag = "v${finalAttrs.version}";
    hash = "sha256-XOXX0NuU+erL/KDAZgBeX+LKO9uSEOyP1/VuMDE5pi0=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ cmake ];

  meta = {
    homepage = "https://github.com/s-yata/marisa-trie";
    changelog = "https://github.com/s-yata/marisa-trie/releases/tag/${finalAttrs.src.tag}";
    description = "Static and space-efficient trie data structure library";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sifmelcara ];
    platforms = lib.platforms.all;
  };
})
