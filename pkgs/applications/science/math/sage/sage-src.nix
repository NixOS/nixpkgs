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
    # https://github.com/sagemath/sage/pull/35584, landed in 10.1.beta1
    (fetchpatch {
      name = "networkx-3.1-upgrade.patch";
      url = "https://github.com/sagemath/sage/commit/be0aab74fd7e399e146988ef27260d2837baebae.diff";
      sha256 = "sha256-xBGrylNaiF7CpfmX9/4lTioP2LSYKoRCkKlKSGZuv9U=";
    })

    # https://github.com/sagemath/sage/pull/35612, landed in 10.1.beta1
    (fetchpatch {
      name = "linbox-1.7-upgrade.patch";
      url = "https://github.com/sagemath/sage/commit/35cbd2f2a2c4c355455d39b1424f05ea0aa4349b.diff";
      sha256 = "sha256-/TpvIQZUqmbUuz6wvp3ni9oRir5LBA2FKDJcmnHI1r4=";
    })

    # https://github.com/sagemath/sage/pull/35619, landed in 10.1.beta1
    (fetchpatch {
      name = "maxima-5.46.0-upgrade.patch";
      url = "https://github.com/sagemath/sage/commit/4ddf9328e7598284d4bc03cd2ed890f0be6b6399.diff";
      sha256 = "sha256-f6YaZiLSj+E0LJMsMZHDt6vecWffSAuUHYVkegBEhno=";
    })

    # https://github.com/sagemath/sage/pull/35635, landed in 10.1.beta1
    (fetchpatch {
      name = "sympy-1.12-upgrade.patch";
      url = "https://github.com/sagemath/sage/commit/1a73b3bbbfa0f4a297e05d49305070e1ed5ae598.diff";
      sha256 = "sha256-k8Oam+EiRcfXC7qCdLacCx+7vpUAw2K1wsjKcQbeGb4=";
    })

    # https://github.com/sagemath/sage/pull/35826, landed in 10.1.beta5
    (fetchpatch {
      name = "numpy-1.25.0-upgrade.patch";
      url = "https://github.com/sagemath/sage/commit/ecfe06b8f1fe729b07e885f0de55244467e5c137.diff";
      sha256 = "sha256-G0xhl+LyNdDYPzRqSHK3fHaepcIzpuwmqRiussraDf0=";
    })

    # https://github.com/sagemath/sage/pull/35826#issuecomment-1658569891
    ./patches/numpy-1.25-deprecation.patch

    # https://github.com/sagemath/sage/pull/35842, landed in 10.1.beta5
    (fetchpatch {
      name = "scipy-1.11-upgrade.patch";
      url = "https://github.com/sagemath/sage/commit/90ece168c3c61508baa36659b0027b7dd8b43add.diff";
      sha256 = "sha256-Y5TmuJcUJR+veb2AuSVODGs+xkVV+pTM8fWTm4q+NDs=";
    })

    # https://github.com/sagemath/sage/pull/35825, landed in 10.1.beta6
    (fetchpatch {
      name = "singular-4.3.2p2-upgrade.patch";
      url = "https://github.com/sagemath/sage/commit/1a1b49f814cdf4c4c8d0ac8930610f3fef6af5b0.diff";
      sha256 = "sha256-GqMgoi0tsP7zcCcPumhdsbvhPB6fgw1ufx6gHlc6iSc=";
    })

    # https://github.com/sagemath/sage/pull/36006, landed in 10.2.beta2
    (fetchpatch {
      name = "gmp-6.3-upgrade.patch";
      url = "https://github.com/sagemath/sage/commit/5e841de46c3baa99cd1145b36ff9163e9340a55c.diff";
      sha256 = "sha256-fJPDryLtGBQz9qHDiCkBwjiW2lN6v7HiHgxY7CTeHcs=";
    })

    # https://github.com/sagemath/sage/pull/36279, landed in 10.2.beta4
    (fetchpatch {
       name = "matplotlib-3.8-upgrade.patch";
       url = "https://github.com/sagemath/sage/commit/0fcf88935908440930c5f79202155aca4ad57518.diff";
       sha256 = "sha256-mvqAHaTCXsxPv901L8HSTnrfghfXYdq0wfLoP/cYQZI=";
    })

    # https://github.com/sagemath/sage/pull/35658, landed in 10.1.beta2
    (fetchpatch {
      name = "sphinx-7-upgrade.patch";
      url = "https://github.com/sagemath/sage/commit/cacd9a89b5c4fdcf84a8dd2b7d5bdc10cc78109a.diff";
      sha256 = "sha256-qJvliTJjR3XBc5pH6Q0jtm8c4bhtZcTcF3O04Ro1uaU=";
    })

    # https://github.com/sagemath/sage/pull/36296, landed in 10.2.beta4
    (fetchpatch {
      name = "duplicate-args-region_plot.patch";
      url = "https://github.com/sagemath/sage/commit/461727b453712550a2c5dc0ae11933523255aaed.diff";
      sha256 = "sha256-mC8084VQoUBk4hocALF+Y9Cwb38Zt360eldi/SSjna8=";
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
