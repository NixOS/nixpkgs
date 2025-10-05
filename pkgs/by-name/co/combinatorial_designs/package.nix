{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "combinatorial_designs";
  version = "20140630";

  src = fetchurl {
    url = "mirror://sageupstream/combinatorial_designs/combinatorial_designs-${version}.tar.bz2";
    sha256 = "0bj8ngiq59hipa6izi6g5ph5akmy4cbk0vlsb0wa67f7grnnqj69";
  };

  installPhase = ''
    mkdir -p "$out/share/combinatorial_designs"
    mv * "$out/share/combinatorial_designs"
  '';

  meta = with lib; {
    description = "Data for Combinatorial Designs";
    longDescription = ''
      Current content:

      - The table of MOLS (10 000 integers) from the Handbook of Combinatorial
        Designs, 2ed.
    '';
    license = licenses.publicDomain;
    platforms = platforms.all;
    teams = [ teams.sage ];
  };
}
