{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "marisa";
  version = "0.2.6";

  src = fetchFromGitHub {
    owner = "s-yata";
    repo = "marisa-trie";
    rev = "v${version}";
    sha256 = "1hy8hfksizk1af6kg8z3b9waiz6d5ggd73fiqcvmhfgra36dscyq";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook ];

  meta = {
    homepage = "https://github.com/s-yata/marisa-trie";
    description = "Static and space-efficient trie data structure library";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ sifmelcara ];
    platforms = lib.platforms.all;
  };
}
