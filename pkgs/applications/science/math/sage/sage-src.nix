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
  version = "8.9";
  pname = "sage-src";

  src = fetchFromGitHub {
    owner = "sagemath";
    repo = "sage";
    rev = version;
    sha256 = "1bwga58x3s8z42w5h51c232f91ndsc1861dlb1glhax3pn0rhn3a";
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

    # Make sure py2/py3 tests are only run when their expected context (all "sage"
    # tests) are also run. That is necessary to test dochtml individually. See
    # https://trac.sagemath.org/ticket/26110 for an upstream discussion.
    ./patches/Only-test-py2-py3-optional-tests-when-all-of-sage-is.patch

    # Fixes a potential race condition which can lead to transient doctest failures.
    ./patches/fix-ecl-race.patch

    # Not necessary since library location is set explicitly
    # https://trac.sagemath.org/ticket/27660#ticket
    ./patches/do-not-test-find-library.patch

    # Parallelize docubuild using subprocesses, fixing an isolation issue. See
    # https://groups.google.com/forum/#!topic/sage-packaging/YGOm8tkADrE
    ./patches/sphinx-docbuild-subprocesses.patch
  ];

  # Since sage unfortunately does not release bugfix releases, packagers must
  # fix those bugs themselves. This is for critical bugfixes, where "critical"
  # == "causes (transient) doctest failures / somebody complained".
  bugfixPatches = [
    # To help debug the transient error in
    # https://trac.sagemath.org/ticket/23087 when it next occurs.
    ./patches/configurationpy-error-verbose.patch
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

    # After updating smypow to (https://trac.sagemath.org/ticket/3360) we can
    # now set the cache dir to be withing the .sage directory. This is not
    # strictly necessary, but keeps us from littering in the user's HOME.
    ./patches/sympow-cache.patch

    # https://trac.sagemath.org/ticket/28472
    (fetchpatch {
      name = "eclib-20190909.patch";
      url = "https://git.sagemath.org/sage.git/patch?id=d27dc479a5772d59e4bc85d805b6ffd595284f1d";
      sha256 = "1nf1s9y7n30lhlbdnam7sghgaq9nasmv96415gl5jlcf7a3hlxk3";
    })

    # ignore a deprecation warning for usage of `cmp` in the attrs library in the doctests
    ./patches/ignore-cmp-deprecation.patch

    # Werkzeug has deprecated ImmutableDict, but it is still used in legacy
    # sagenb. That's no big issue since sagenb will be removed soon anyways.
    ./patches/ignore-werkzeug-immutable-dict-deprecation.patch

    # threejs r109 (#28560)
    (fetchpatch {
      name = "threejs-r109.patch";
      url = "https://git.sagemath.org/sage.git/patch?id=fcc11d6effa39f375bc5f4ea5831fb7a2f2767da";
      sha256 = "0hnmc8ld3bblks0hcjvjjaydkgwdr1cs3dbl2ys4gfq964pjgqwc";
    })

    # https://trac.sagemath.org/ticket/28911
    (fetchpatch {
      name = "sympy-1.5.patch";
      url = "https://git.sagemath.org/sage.git/patch/?h=c6d0308db15efd611211d26cfcbefbd180fc0831";
      sha256 = "0nwai2jr22h49km4hx3kwafs3mzsc5kwsv7mqwjf6ibwfx2bbgyq";
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

    # Make sure sage can at least be imported without setting any environment
    # variables. It won't be close to feature complete though.
    sed -i \
      "s|var('SAGE_LOCAL',.*|var('SAGE_LOCAL', '$out/src')|" \
      src/sage/env.py

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
