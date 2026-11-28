{
  lib,
  stdenv,
  fetchurl,
  singular,
  defaultDimension ? 6, # the dimension for the default executables to be symlinked to
  doSymlink ? true, # symlink the executables to the default location (without dimension postfix)
}:

let
  dim = toString defaultDimension;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "palp";
  version = "2.21";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchurl {
    url = "https://hep.itp.tuwien.ac.at/~kreuzer/CY/palp/palp-${finalAttrs.version}.tar.gz";
    hash = "sha256-fkp78hmZioRMC8zgoXbknQdDy0tQWg4ZUym/LsGW3dc=";
  };

  hardeningDisable = [
    "format"
  ];

  postPatch = lib.optionalString stdenv.hostPlatform.isDarwin ''
    substituteInPlace GNUmakefile --replace gcc cc
    patchShebangs --build tests
  '';

  enableParallelBuilding = true;

  buildFlags = [
    "all-dims"
  ];

  doCheck = true;
  nativeCheckInputs = [
    singular
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    for file in poly class cws nef mori; do
      cp -p $file-*.x $out/bin
    done
    runHook postInstall
  '';

  postInstall = lib.optionalString doSymlink ''
    cd $out/bin
    for file in poly class cws nef mori; do
      ln -sf $file-${dim}d.x $file.x
    done
  '';

  meta = {
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
    homepage = "https://hep.itp.tuwien.ac.at/~kreuzer/CY/CYpalp.html";
    # Not really a changelog, but a one-line summary of each update that should
    # be reviewed on update.
    changelog = "https://hep.itp.tuwien.ac.at/~kreuzer/CY/CYpalp.html";
    license = lib.licenses.gpl3Only;
    teams = [ lib.teams.sage ];
    platforms = lib.platforms.unix;
  };
})
