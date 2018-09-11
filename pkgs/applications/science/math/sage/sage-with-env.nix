{ stdenv
, lib
, makeWrapper
, sage-env
, sage-src
, openblasCompat
, openblas-blas-pc
, openblas-cblas-pc
, openblas-lapack-pc
, pkg-config
, three
, singular
, libgap
, gap-libgap-compatible
, giac
, maxima-ecl
, pari
, gmp
, gfan
, python2
, flintqs
, eclib
, ntl
, ecm
, pynac
, pythonEnv
}:

let
  buildInputs = [
    pythonEnv # for patchShebangs
    makeWrapper
    pkg-config
    openblasCompat # lots of segfaults with regular (64 bit) openblas
    openblas-blas-pc
    openblas-cblas-pc
    openblas-lapack-pc
    singular
    three
    pynac
    giac
    libgap
    gap-libgap-compatible
    pari
    gmp
    gfan
    maxima-ecl
    eclib
    flintqs
    ntl
    ecm
  ];

  # remove python prefix, replace "-" in the name by "_", apply patch_names
  # python2.7-some-pkg-1.0 -> some_pkg-1.0
  pkg_to_spkg_name = pkg: patch_names: let
    parts = lib.splitString "-" pkg.name;
    # remove python2.7-
    stripped_parts = if (builtins.head parts) == python2.libPrefix then builtins.tail parts else parts;
    version = lib.last stripped_parts;
    orig_pkgname = lib.init stripped_parts;
    pkgname = patch_names (lib.concatStringsSep "_" orig_pkgname);
  in pkgname + "-" + version;


  # return the names of all dependencies in the transitive closure
  transitiveClosure = dep:
  if isNull dep then
    # propagatedBuildInputs might contain null
    # (although that might be considered a programming error in the derivation)
    []
  else
    [ dep ] ++ (
      if builtins.hasAttr "propagatedBuildInputs" dep then
        lib.unique (builtins.concatLists (map transitiveClosure dep.propagatedBuildInputs))
      else
      []
    );

  allInputs = lib.remove null (buildInputs ++ pythonEnv.extraLibs);
  transitiveDeps = lib.unique (builtins.concatLists (map transitiveClosure allInputs ));
  # fix differences between spkg and sage names
  # (could patch sage instead, but this is more lightweight and also works for packages depending on sage)
  patch_names = builtins.replaceStrings [
    "zope.interface"
    "node_three"
  ] [
    "zope_interface"
    "threejs"
  ];
  # spkg names (this_is_a_package-version) of all transitive deps
  input_names = map (dep: pkg_to_spkg_name dep patch_names) transitiveDeps;
in
stdenv.mkDerivation rec {
  version = sage-src.version;
  name = "sage-with-env-${version}";

  inherit buildInputs;

  src = sage-src;

  configurePhase = "#do nothing";

  buildPhase = ''
    mkdir installed
    for pkg in ${lib.concatStringsSep " " input_names}; do
      touch "installed/$pkg"
    done
  '';

  installPhase = ''
    mkdir -p "$out/var/lib/sage"
    cp -r installed $out/var/lib/sage

    mkdir -p "$out/etc"
    # sage tests will try to create this file if it doesn't exist
    touch "$out/etc/sage-started.txt"

    mkdir -p "$out/build"
    cp -r src/bin "$out/bin"
    cp -r build/bin "$out/build/bin"
    cp -f '${sage-env}/sage-env' "$out/bin/sage-env"
    substituteInPlace "$out/bin/sage-env" \
      --subst-var-by sage-local "$out"
  '';
}
