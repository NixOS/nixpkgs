{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "combinatorial_designs";
  version = "20140630";

  src = fetchurl {
    url = "mirror://sageupstream/combinatorial_designs/combinatorial_designs-${finalAttrs.version}.tar.bz2";
    sha256 = "0bj8ngiq59hipa6izi6g5ph5akmy4cbk0vlsb0wa67f7grnnqj69";
  };

  installPhase = ''
    mkdir -p "$out/share/combinatorial_designs"
    mv * "$out/share/combinatorial_designs"
  '';

  meta = {
    description = "Data for Combinatorial Designs";
    longDescription = ''
      Current content:

      - The table of MOLS (10 000 integers) from the Handbook of Combinatorial
        Designs, 2ed.
    '';
    license = lib.licenses.publicDomain;
    platforms = lib.platforms.all;
    teams = [ lib.teams.sage ];
  };
})
