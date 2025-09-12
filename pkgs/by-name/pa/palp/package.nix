{
  lib,
  stdenv,
  fetchurl,
  dimensions ? 6, # works for <= dimensions dimensions, but is only optimized for that exact value
  doSymlink ? true, # symlink the executables to the default location (without dimension postfix)
}:

let
  dim = toString dimensions;
in
stdenv.mkDerivation rec {
  pname = "palp";
  version = "2.21";

  src = fetchurl {
    url = "http://hep.itp.tuwien.ac.at/~kreuzer/CY/palp/${pname}-${version}.tar.gz";
    sha256 = "sha256-fkp78hmZioRMC8zgoXbknQdDy0tQWg4ZUym/LsGW3dc=";
  };

  hardeningDisable = [
    "format"
  ];

  patchPhase = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace GNUmakefile --replace gcc cc
  '';

  preBuild = ''
    echo Building PALP optimized for ${dim} dimensions
    sed -i "s/^#define[^a-zA-Z]*POLY_Dmax.*/#define POLY_Dmax ${dim}/" Global.h
  '';

  # palp has no tests of its own. This test is an adapted sage test that failed
  # when #28029 was merged.
  doCheck = true;
  checkPhase = ''
    ./nef.x -f -N << EOF | grep -q 'np='
      3 6
      1  0  0 -1  0  0
      0  1  0  0 -1  0
      0  0  1  0  0 -1
    EOF
  '';

  installPhase = ''
    mkdir -p $out/bin
    for file in poly class cws nef mori; do
      cp -p $file.x "$out/bin/$file-${dim}d.x"
    done
  ''
  + lib.optionalString doSymlink ''
    cd $out/bin
    for file in poly class cws nef mori; do
      ln -sf $file-6d.x $file.x
    done
  '';

  meta = with lib; {
    description = "Package for Analyzing Lattice Polytopes";
    longDescription = ''
      A Package for Analyzing Lattice Polytopes (PALP) is a set of C
      programs for calculations with lattice polytopes and applications to
      toric geometry.

      It contains routines for vertex and facet enumeration, computation of
      incidences and symmetries, as well as completion of the set of lattice
      points in the convex hull of a given set of points. In addition, there
      are procedures specialised to reflexive polytopes such as the
      enumeration of reflexive subpolytopes, and applications to toric
      geometry and string theory, like the computation of Hodge data and
      fibration structures for toric Calabi-Yau varieties.  The package is
      well tested and optimised in speed as it was used for time consuming
      tasks such as the classification of reflexive polyhedra in 4
      dimensions and the creation and manipulation of very large lists of
      5-dimensional polyhedra.

      While originally intended for low-dimensional applications, the
      algorithms work in any dimension and our key routine for vertex and
      facet enumeration compares well with existing packages.
    '';
    homepage = "http://hep.itp.tuwien.ac.at/~kreuzer/CY/CYpalp.html";
    # Not really a changelog, but a one-line summary of each update that should
    # be reviewed on update.
    changelog = "http://hep.itp.tuwien.ac.at/~kreuzer/CY/CYpalp.html";
    # Just a link on the website pointing to gpl -- now gplv3. When the last
    # version was released that pointed to gplv2 however, so thats probably
    # the right license.
    license = licenses.gpl2;
    teams = [ teams.sage ];
    platforms = platforms.unix;
  };
}
