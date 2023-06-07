{ stdenv
, fetchFromGitHub
, fetchpatch
}:

# This file is responsible for fetching the sage source and adding necessary patches.
# It does not actually build anything, it just copies the patched sources to $out.
# This is done because multiple derivations rely on these sources and they should
# all get the same sources with the same patches applied.

stdenv.mkDerivation rec {
  version = "10.0";
  pname = "sage-src";

  src = fetchFromGitHub {
    owner = "sagemath";
    repo = "sage";
    rev = version;
    sha256 = "sha256-zN/Lo/GBCjYGemuaYpgG3laufN8te3wPjXMQ+Me9zgY=";
  };

  # Patches needed because of particularities of nix or the way this is packaged.
  # The goal is to upstream all of them and get rid of this list.
  nixPatches = [
    # Parallelize docubuild using subprocesses, fixing an isolation issue. See
    # https://groups.google.com/forum/#!topic/sage-packaging/YGOm8tkADrE
    ./patches/sphinx-docbuild-subprocesses.patch

    # After updating smypow to (https://github.com/sagemath/sage/issues/3360)
    # we can now set the cache dir to be within the .sage directory. This is
    # not strictly necessary, but keeps us from littering in the user's HOME.
    ./patches/sympow-cache.patch
  ];

  # Since sage unfortunately does not release bugfix releases, packagers must
  # fix those bugs themselves. This is for critical bugfixes, where "critical"
  # == "causes (transient) doctest failures / somebody complained".
  bugfixPatches = [
    # Sage uses mixed integer programs (MIPs) to find edge disjoint
    # spanning trees. For some reason, aarch64 glpk takes much longer
    # than x86_64 glpk to solve such MIPs. Since the MIP formulation
    # has "numerous problems" and will be replaced by a polynomial
    # algorithm soon, disable this test for now.
    # https://github.com/sagemath/sage/issues/34575
    ./patches/disable-slow-glpk-test.patch
  ];

  # Patches needed because of package updates. We could just pin the versions of
  # dependencies, but that would lead to rebuilds, confusion and the burdons of
  # maintaining multiple versions of dependencies. Instead we try to make sage
  # compatible with never dependency versions when possible. All these changes
  # should come from or be proposed to upstream. This list will probably never
  # be empty since dependencies update all the time.
  packageUpgradePatches = [
    # https://github.com/sagemath/sage/pull/35584, positively reviewed
    (fetchpatch {
      name = "networkx-3.1-upgrade.patch";
      url = "https://github.com/sagemath/sage/compare/10.0.rc2..e599562cf5fdfb9799a5412fac40c2f8e9f97341.diff";
      sha256 = "sha256-3A90kXqNR0c7+k8xrZXAt5wqWg/VFAPNhQujwTdOyhI=";
    })

    # https://github.com/sagemath/sage/pull/35612, positively reviewed
    (fetchpatch {
      name = "linbox-1.7-upgrade.patch";
      url = "https://github.com/sagemath/sage/compare/10.0.rc2..9c8796c7b677e3a056348e3510331ea8b8c3c42e.diff";
      sha256 = "sha256-/TpvIQZUqmbUuz6wvp3ni9oRir5LBA2FKDJcmnHI1r4=";
    })

    # https://github.com/sagemath/sage/pull/35619
    (fetchpatch {
      name = "maxima-5.46.0-upgrade.patch";
      url = "https://github.com/sagemath/sage/compare/10.0.rc3..7e86af5dae8f89868b25a6f57189bb5ca618da89.diff";
      sha256 = "sha256-pxSxdJ2lyHoMUIxhlIn1nTHaddRxGvvTj9IbwFCTBFU=";
    })

    # https://github.com/sagemath/sage/pull/35635, positively reviewed
    (fetchpatch {
      name = "sympy-1.12-upgrade.patch";
      url = "https://github.com/sagemath/sage/compare/10.0.rc2..aa4193cdc8ec9fb7bd7c49696b7f914668f7913a.diff";
      sha256 = "sha256-UAmYCxHvnE5p+H2DySNZTPFVm915jHtOEoG+tZz5n7I=";
    })
  ];

  patches = nixPatches ++ bugfixPatches ++ packageUpgradePatches;

  # do not create .orig backup files if patch applies with fuzz
  patchFlags = [ "--no-backup-if-mismatch" "-p1" ];

  postPatch = ''
    # Make sure sage can at least be imported without setting any environment
    # variables. It won't be close to feature complete though.
    sed -i \
      "s|var(\"SAGE_ROOT\".*|var(\"SAGE_ROOT\", \"$out\")|" \
      src/sage/env.py
  '';

  buildPhase = "# do nothing";

  installPhase = ''
    cp -r . "$out"
  '';
}
