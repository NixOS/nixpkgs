{ stdenv
, fetchFromGitHub
, fetchpatch
}:

# This file is responsible for fetching the sage source and adding necessary patches.
# It does not actually build anything, it just copies the patched sources to $out.
# This is done because multiple derivations rely on these sources and they should
# all get the same sources with the same patches applied.

stdenv.mkDerivation rec {
  version = "8.4";
  name = "sage-src-${version}";

  src = fetchFromGitHub {
    owner = "sagemath";
    repo = "sage";
    rev = version;
    sha256 = "0gips1hagiz9m7s21bg5as8hrrm2x5k47h1bsq0pc46iplfwmv2d";
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
    fetchSageDiff = { base, rev, ...}@args: (
      fetchpatch ({
        url = "https://git.sagemath.org/sage.git/patch?id2=${base}&id=${rev}";
        # We don't care about sage's own build system (which builds all its dependencies).
        # Exclude build system changes to avoid conflicts.
        excludes = [ "build/*" ];
      } // builtins.removeAttrs args [ "rev" "base" ])
    );
  in [
    # New glpk version has new warnings, filter those out until upstream sage has found a solution
    # https://trac.sagemath.org/ticket/24824
    ./patches/pari-stackwarn.patch # not actually necessary since the pari upgrade, but necessary for the glpk patch to apply
    (fetchpatch {
      url = "https://salsa.debian.org/science-team/sagemath/raw/58bbba93a807ca2933ca317501d093a1bb4b84db/debian/patches/dt-version-glpk-4.65-ignore-warnings.patch";
      sha256 = "0b9293v73wb4x13wv5zwyjgclc01zn16msccfzzi6znswklgvddp";
      stripLen = 1;
    })

    # https://trac.sagemath.org/ticket/25260
    ./patches/numpy-1.15.1.patch

    # https://trac.sagemath.org/ticket/26315
    ./patches/giac-1.5.0.patch

    # needed for ntl update
    # https://trac.sagemath.org/ticket/25532
    (fetchpatch {
      name = "lcalc-c++11.patch";
      url = "https://git.archlinux.org/svntogit/community.git/plain/trunk/sagemath-lcalc-c++11.patch?h=packages/sagemath&id=0e31ae526ab7c6b5c0bfacb3f8b1c4fd490035aa";
      sha256 = "0p5wnvbx65i7cp0bjyaqgp4rly8xgnk12pqwaq3dqby0j2bk6ijb";
    })

    (fetchpatch {
      name = "cython-0.29.patch";
      url = "https://git.sagemath.org/sage.git/patch/?h=f77de1d0e7f90ee12761140500cb8cbbb789ab20";
      sha256 = "14wrpy8jgbnpza1j8a2nx8y2r946y82pll1fv3cn6gpfmm6640l3";
    })
    # https://trac.sagemath.org/ticket/26360
    (fetchpatch {
      name = "arb-2.15.1.patch";
      url = "https://git.sagemath.org/sage.git/patch/?id=30cc778d46579bd0c7537ed33e8d7a4f40fd5c31";
      sha256 = "13vc2q799dh745sm59xjjabllfj0sfjzcacf8k59kwj04x755d30";
    })

    # https://trac.sagemath.org/ticket/26326
    # needs to be split because there is a merge commit in between
    (fetchSageDiff {
      name = "networkx-2.2-1.patch";
      base = "8.4";
      rev = "68f5ad068184745b38ba6716bf967c8c956c52c5";
      sha256 = "112b5ywdqgyzgvql2jj5ss8la9i8rgnrzs8vigsfzg4shrcgh9p6";
    })
    (fetchSageDiff {
      name = "networkx-2.2-2.patch";
      base = "626485bbe5f33bf143d6dfba4de9c242f757f59b~1";
      rev = "db10d327ade93711da735a599a67580524e6f7b4";
      sha256 = "09v87id25fa5r9snfn4mv79syhc77jxfawj5aizmdpwdmpgxjk1f";
    })
  ];

  patches = nixPatches ++ packageUpgradePatches;

  postPatch = ''
    # make sure shebangs etc are fixed, but sage-python23 still works
    find . -type f -exec sed \
      -e 's/sage-python23/python/g' \
      -i {} \;

    echo '#!${stdenv.shell}
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
