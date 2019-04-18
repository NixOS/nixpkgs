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
  version = "8.8.beta2";
  pname = "sage-src";

  src = fetchFromGitHub {
    owner = "sagemath";
    repo = "sage";
    rev = version;
    sha256 = "1avrxhhcd1hy4hm9sgma430hvxg36f10kr9p3himj6kl4m9pyflv";
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

    # Part of the build system. Should become unnecessary with sage 8.8.
    # Upstream discussion here: https://trac.sagemath.org/ticket/27124#comment:33
    ./patches/do-not-test-package-manifests.patch

    # Not necessary since library location is set explicitly
    # https://trac.sagemath.org/ticket/27660#ticket
    ./patches/do-not-test-find-library.patch

    # https://trac.sagemath.org/ticket/27697#ticket
    (fetchpatch {
      name = "pplpy-doc-location-configurable.patch";
      url = "https://git.sagemath.org/sage.git/patch/?h=c4d966e7cb0c7b87c55d52dc6f46518433a2a0a2";
      sha256 = "0pqbbsx8mriwny422s9mp3z5d095cnam32sm62q4mxk8g8jb9vm9";
    })

    # https://trac.sagemath.org/ticket/28007
    ./patches/threejs-offline.patch

    # Parallelize docubuild using subprocesses, fixing an isolation issue. See
    # https://groups.google.com/forum/#!topic/sage-packaging/YGOm8tkADrE
    ./patches/sphinx-docbuild-subprocesses.patch
  ];

  # Since sage unfortunately does not release bugfix releases, packagers must
  # fix those bugs themselves. This is for critical bugfixes, where "critical"
  # == "causes (transient) doctest failures / somebody complained".
  bugfixPatches = [ ];

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

    # https://trac.sagemath.org/ticket/27653
    (fetchpatch {
      name = "sympy-1.4.patch";
      url = "https://git.sagemath.org/sage.git/patch/?h=3277ba76d0ba7174608a31a0c6623e9210c63e3d";
      sha256 = "09avaanwmdgqv14mmllbgw9z2scf4lc0y0kzdhlriiq8ss9j8iir";
    })

    # https://trac.sagemath.org/ticket/27738
    (fetchpatch {
      name = "R-3.6.0.patch";
      url = "https://git.sagemath.org/sage.git/patch/?h=8b7dbd0805d02d0e8674a272e161ceb24a637966";
      sha256 = "1c81f13z1w62s06yvp43gz6vkp8mxcs289n6l4gj9xj10slimzff";
    })

    # https://trac.sagemath.org/ticket/26932
    (fetchSageDiff {
      name = "givaro-4.1.0_fflas-ffpack-2.4.0_linbox-1.6.0.patch";
      base = "8.8.beta4";
      rev = "c11d9cfa23ff9f77681a8f12742f68143eed4504";
      sha256 = "0xzra7mbgqvahk9v45bjwir2mqz73hrhhy314jq5nxrb35ysdxyi";
    })

    # https://trac.sagemath.org/ticket/26718
    (fetchpatch {
      name = "threejs-r100.patch";
      url = "https://git.sagemath.org/sage.git/patch/?h=86c5bb000259e6de5d7c60afc608a4b0d010b690";
      sha256 = "0sgqqd4df2bxsq19b6kfy7dvgyxprlpg7f3xx7g3fs8ij937m352";
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
