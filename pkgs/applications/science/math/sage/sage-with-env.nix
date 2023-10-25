{ stdenv
, lib
, makeWrapper
, sage-env
, blas
, lapack
, pkg-config
, three
, singular
, gap
, giac
, maxima
, pari
, gmp
, gfan
, python3
, flintqs
, eclib
, ntl
, ecm
, pythonEnv
}:

# lots of segfaults with (64 bit) blas
assert (!blas.isILP64) && (!lapack.isILP64);

# Wrapper that combined `sagelib` with `sage-env` to produce an actually
# executable sage. No tests are run yet and no documentation is built.

let
  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    pythonEnv # for patchShebangs
    blas lapack
    singular
    three
    giac
    gap
    pari
    gmp
    gfan
    maxima
    eclib
    flintqs
    ntl
    ecm
  ];

  # remove python prefix, replace "-" in the name by "_", apply patch_names
  # python3.8-some-pkg-1.0 -> some_pkg-1.0
  pkg_to_spkg_name = pkg: patch_names: let
    parts = lib.splitString "-" pkg.name;
    # remove python3.8-
    stripped_parts = if (builtins.head parts) == python3.libPrefix then builtins.tail parts else parts;
    version = lib.last stripped_parts;
    orig_pkgname = lib.init stripped_parts;
    pkgname = patch_names (lib.concatStringsSep "_" orig_pkgname);
  in pkgname + "-" + version;


  # return the names of all dependencies in the transitive closure
  transitiveClosure = dep:
  if dep == null then
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

  allInputs = lib.remove null (nativeBuildInputs ++ buildInputs ++ pythonEnv.extraLibs ++ [ makeWrapper ]);
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
  version = src.version;
  pname = "sage-with-env";
  src = sage-env.lib.src;

  inherit nativeBuildInputs buildInputs;

  configurePhase = "#do nothing";

  buildPhase = ''
    mkdir installed
    for pkg in ${lib.concatStringsSep " " input_names}; do
      touch "installed/$pkg"
    done

    # threejs version is in format 0.<version>.minor, but sage currently still
    # relies on installed_packages for the online version of threejs to work
    # and expects the format r<version>. This is a hotfix for now.
    # upstream: https://trac.sagemath.org/ticket/26434
    rm "installed/threejs"*
    touch "installed/threejs-r${lib.versions.minor three.version}"
  '';

  installPhase = ''
    mkdir -p "$out/var/lib/sage"
    cp -r installed "$out/var/lib/sage"

    mkdir -p "$out/etc"
    # sage tests will try to create this file if it doesn't exist
    touch "$out/etc/sage-started.txt"

    mkdir -p "$out/build"

    # the scripts in src/bin will find the actual sage source files using environment variables set in `sage-env`
    cp -r src/bin "$out/bin"
    cp -r build/bin "$out/build/bin"

    # sage assumes the existence of sage-src-env-config.in means it's being executed in-tree. in this case, it
    # adds SAGE_SRC/bin to PATH, breaking our wrappers
    rm "$out/bin"/*.in "$out/build/bin"/*.in

    cp -f '${sage-env}/sage-env' "$out/bin/sage-env"
    substituteInPlace "$out/bin/sage-env" \
      --subst-var-by sage-local "$out"
  '';

  passthru = {
    env = sage-env;
  };
}
