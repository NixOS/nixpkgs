{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
}:

stdenv.mkDerivation rec {
  pname = "marisa";
  version = "0.2.7";

  src = fetchFromGitHub {
    owner = "s-yata";
    repo = "marisa-trie";
    rev = "v${version}";
    sha256 = "sha256-+OGtDbwl7ar3i65POkTGyC4AYkOT4YuASfdt5FGJ8yM=";
  };

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    homepage = "https://github.com/s-yata/marisa-trie";
    description = "Static and space-efficient trie data structure library";
    license = licenses.bsd3;
    maintainers = with maintainers; [ sifmelcara ];
    platforms = platforms.all;
  };
}
