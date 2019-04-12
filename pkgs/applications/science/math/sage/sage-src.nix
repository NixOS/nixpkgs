{ stdenv
, fetchFromGitHub
, fetchpatch
, runtimeShell
}:

# This file is responsible for fetching the sage source and adding necessary patches.
# It does not actually build anything, it just copies the patched sources to $out.
# This is done because multiple derivations rely on these sources and they should
# all get the same sources with the same patches applied.

stdenv.mkDerivation rec {
  version = "8.6";
  name = "sage-src-${version}";

  src = fetchFromGitHub {
    owner = "sagemath";
    repo = "sage";
    rev = version;
    sha256 = "1vs3pbgbqpg0qnwr018bqsdmm7crgjp310cx8zwh7za3mv1cw5j3";
  };

  # Patches needed because of particularities of nix or the way this is packaged.
  # The goal is to upstream all of them and get rid of this list.
  nixPatches = [
    # https://trac.sagemath.org/ticket/25358
    (fetchpatch {
      name = "safe-directory-test-without-patch.patch";
      url = "https://git.sagemath.org/sage.git/patch?id2=8bdc326ba57d1bb9664f63cf165a9e9920cc1afc&id=dc673c17555efca611f68398d5013b66e9825463";
      sha256 = "1hhannz7xzprijakn2w2d0rhd5zv2zikik9p51i87bas3nc658f7";
    })

    # Unfortunately inclusion in upstream sage was rejected. Instead the bug was
    # fixed in python, but of course not backported to 2.7. So we'll probably
    # have to keep this around until 2.7 is deprecated.
    # https://trac.sagemath.org/ticket/25316
    # https://github.com/python/cpython/pull/7476
    ./patches/python-5755-hotpatch.patch

    # Revert the commit that made the sphinx build fork even in the single thread
    # case. For some yet unknown reason, that breaks the docbuild on nix and archlinux.
    # See https://groups.google.com/forum/#!msg/sage-packaging/VU4h8IWGFLA/mrmCMocYBwAJ.
    # https://trac.sagemath.org/ticket/26608
    ./patches/revert-sphinx-always-fork.patch

    # Make sure py2/py3 tests are only run when their expected context (all "sage"
    # tests) are also run. That is necessary to test dochtml individually. See
    # https://trac.sagemath.org/ticket/26110 for an upstream discussion.
    ./patches/Only-test-py2-py3-optional-tests-when-all-of-sage-is.patch

    # Fixes a potential race condition which can lead to transient doctest failures.
    ./patches/fix-ecl-race.patch

    # Parallelize docubuild using subprocesses, fixing an isolation issue. See
    # https://groups.google.com/forum/#!topic/sage-packaging/YGOm8tkADrE
    (fetchpatch {
      name = "sphinx-docbuild-subprocesses.patch";
      url = "https://salsa.debian.org/science-team/sagemath/raw/8a215b17e6f791ddfae6df8ce6d01dfb89acb434/debian/patches/df-subprocess-sphinx.patch";
      sha256 = "07p9i0fwjgapmfvmi436yn6v60p8pvmxqjc93wsssqgh5kd8qw3n";
      stripLen = 1;
    })
  ];

  # Since sage unfortunately does not release bugfix releases, packagers must
  # fix those bugs themselves. This is for critical bugfixes, where "critical"
  # == "causes (transient) doctest failures / somebody complained".
  bugfixPatches = [
    # Transient doctest failure in src/sage/modular/abvar/torsion_subgroup.py
    # https://trac.sagemath.org/ticket/27477
    (fetchpatch {
      name = "sig_on_in_matrix_sparce.patch";
      url = "https://git.sagemath.org/sage.git/patch?id2=10407524b18659e14e184114b61c043fb816f3c2&id=c9b0cc9d0b8748ab85e568f8f57f316c5e8cbe54";
      sha256 = "0wgp7yvn9sm1ynlhcr4l0hzmvr2n28llg4xc01p6k1zz4im64c17";
    })
  ];

  # Patches needed because of package updates. We could just pin the versions of
  # dependencies, but that would lead to rebuilds, confusion and the burdons of
  # maintaining multiple versions of dependencies. Instead we try to make sage
  # compatible with never dependency versions when possible. All these changes
  # should come from or be proposed to upstream. This list will probably never
  # be empty since dependencies update all the time.
  packageUpgradePatches = let
    # Fetch a diff between `base` and `rev` on sage's git server.
    # Used to fetch trac tickets by setting the `base` to the last release and the
    # `rev` to the last commit of the ticket.
    fetchSageDiff = { base, rev, name ? "sage-diff-${base}-${rev}.patch", ...}@args: (
      fetchpatch ({
        inherit name;
        url = "https://git.sagemath.org/sage.git/patch?id2=${base}&id=${rev}";
        # We don't care about sage's own build system (which builds all its dependencies).
        # Exclude build system changes to avoid conflicts.
        excludes = [ "build/*" ];
      } // builtins.removeAttrs args [ "rev" "base" ])
    );
  in [
    # New glpk version has new warnings, filter those out until upstream sage has found a solution
    # Should be fixed with glpk > 4.65.
    # https://trac.sagemath.org/ticket/24824
    ./patches/pari-stackwarn.patch # not actually necessary since the pari upgrade, but necessary for the glpk patch to apply
    (fetchpatch {
      url = "https://salsa.debian.org/science-team/sagemath/raw/58bbba93a807ca2933ca317501d093a1bb4b84db/debian/patches/dt-version-glpk-4.65-ignore-warnings.patch";
      sha256 = "0b9293v73wb4x13wv5zwyjgclc01zn16msccfzzi6znswklgvddp";
      stripLen = 1;
    })

    # https://trac.sagemath.org/ticket/26315
    ./patches/giac-1.5.0.patch

    # https://trac.sagemath.org/ticket/26442
    (fetchSageDiff {
      name = "cypari2-2.0.3.patch";
      base = "8.6.rc1";
      rev = "cd62d45bcef93fb4f7ed62609a46135e6de07051";
      sha256 = "08l2b9w0rn1zrha6188j72f7737xs126gkgmydjd31baa6367np2";
    })

    # https://trac.sagemath.org/ticket/26949
    (fetchpatch {
      name = "sphinx-1.8.3-dependency.patch";
      url = "https://git.sagemath.org/sage.git/patch?id=d305eda0fedc73fdbe0447b5d6d2b520b8d112c4";
      sha256 = "1x3q5j8lq35vlj893gj5gq9fhzs60szm9r9rx6ri79yiy9apabph";
    })
    # https://trac.sagemath.org/ticket/26451
    (fetchpatch {
      name = "sphinx-1.8.3.patch";
      url = "https://git.sagemath.org/sage.git/patch?id2=0cb494282d7b4cea50aba7f4d100e7932a4c00b1&id=62b989d5ee1d9646db85ea56053cd22e9ffde5ab";
      sha256 = "1n5c61mvhalcr2wbp66wzsynwwk59aakvx3xqa5zw9nlkx3rd0h1";
    })

    # https://trac.sagemath.org/ticket/27061
    (fetchpatch {
      name = "numpy-1.16-inline-fortran.patch";
      url = "https://git.sagemath.org/sage.git/patch?id=a05b6b038e1571ab15464e98f76d1927c0c3fd12";
      sha256 = "05yq97pq84xi60wb1p9skrad5h5x770gq98ll4frr7hvvmlwsf58";
    })

    # https://trac.sagemath.org/ticket/27405
    ./patches/ignore-pip-deprecation.patch

    # https://trac.sagemath.org/ticket/27360
    (fetchpatch {
      name = "eclib-20190226.patch";
      url = "https://git.sagemath.org/sage.git/patch/?id=f570e3a7fc2965764b84c04ce301a88ded2c42df";
      sha256 = "0l5c4giixkn15v2a06sfzq5mkxila6l67zkjbacirwprrlpcnmmp";
    })

    # https://trac.sagemath.org/ticket/27420
    (fetchpatch {
      name = "cypari-2.1.patch";
      url = "https://git.sagemath.org/sage.git/patch/?id=e351bf2f2914e683d5e2028597c45ae8d1b7f855";
      sha256 = "00faa7fl0vaqcqbw0bidkhl78qa8l34d3a07zirbcl0vm74bdn1p";
    })
  ];

  patches = nixPatches ++ bugfixPatches ++ packageUpgradePatches;

  postPatch = ''
    # make sure shebangs etc are fixed, but sage-python23 still works
    find . -type f -exec sed \
      -e 's/sage-python23/python/g' \
      -i {} \;

    echo '#!${runtimeShell}
    python "$@"' > build/bin/sage-python23

    # Do not use sage-env-config (generated by ./configure).
    # Instead variables are set manually.
    echo '# do nothing' >  src/bin/sage-env-config
  '';

  configurePhase = "# do nothing";

  buildPhase = "# do nothing";

  installPhase = ''
    cp -r . "$out"
  '';
}
