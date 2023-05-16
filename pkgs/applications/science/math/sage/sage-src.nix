{ stdenv
, fetchFromGitHub
, fetchpatch
}:

# This file is responsible for fetching the sage source and adding necessary patches.
# It does not actually build anything, it just copies the patched sources to $out.
# This is done because multiple derivations rely on these sources and they should
# all get the same sources with the same patches applied.

<<<<<<< HEAD
stdenv.mkDerivation rec {
  version = "10.0";
=======
let
  # Fetch a diff between `base` and `rev` on sage's git server.
  # Used to fetch trac tickets by setting the `base` to the last release and the
  # `rev` to the last commit of the ticket.
  #
  # We don't use sage's own build system (which builds all its
  # dependencies), so we exclude changes to "build/" from patches by
  # default to avoid conflicts.
  fetchSageDiff = { base, name, rev, sha256, squashed ? false, excludes ? [ "build/*" ]
                  , ...}@args: (
    fetchpatch ({
      inherit name sha256 excludes;

      # There are three places to get changes from:
      #
      # 1) From Sage's Trac. Contains all release tags (like "9.4") and all developer
      # branches (wip patches from tickets), but exports each commit as a separate
      # patch, so merge commits can lead to conflicts. Used if squashed == false.
      #
      # The above is the preferred option. To use it, find a Trac ticket and pass the
      # "Commit" field from the ticket as "rev", choosing "base" as an appropriate
      # release tag, i.e. a tag that doesn't cause the patch to include a lot of
      # unrelated changes. If there is no such tag (due to nonlinear history, for
      # example), there are two other options, listed below.
      #
      # 2) From GitHub's sagemath/sage repo. This lets us use a GH feature that allows
      # us to choose between a .patch file, with one patch per commit, or a .diff file,
      # which squashes all commits into a single diff. This is used if squashed ==
      # true. This repo has all release tags. However, it has no developer branches, so
      # this option can't be used if a change wasn't yet shipped in a (possibly beta)
      # release.
      #
      # 3) From GitHub's sagemath/sagetrac-mirror repo. Mirrors all developer branches,
      # but has no release tags. The only use case not covered by 1 or 2 is when we need
      # to apply a patch from an open ticket that contains merge commits.
      #
      # Item 3 could cover all use cases if the sagemath/sagetrack-mirror repo had
      # release tags, but it requires a sha instead of a release number in "base", which
      # is inconvenient.
      urls = if squashed
             then [
               "https://github.com/sagemath/sage/compare/${base}...${rev}.diff"
               "https://github.com/sagemath/sagetrac-mirror/compare/${base}...${rev}.diff"
             ]
             else [ "https://git.sagemath.org/sage.git/patch?id2=${base}&id=${rev}" ];
    } // builtins.removeAttrs args [ "rev" "base" "sha256" "squashed" "excludes" ])
  );
in
stdenv.mkDerivation rec {
  version = "9.8";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  pname = "sage-src";

  src = fetchFromGitHub {
    owner = "sagemath";
    repo = "sage";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-zN/Lo/GBCjYGemuaYpgG3laufN8te3wPjXMQ+Me9zgY=";
=======
    sha256 = "sha256-dDbrzJXsOBARYfJz0r7n3LbaoXHnx7Acz6HBa95NV9o=";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  # Patches needed because of particularities of nix or the way this is packaged.
  # The goal is to upstream all of them and get rid of this list.
  nixPatches = [
<<<<<<< HEAD
    # Parallelize docubuild using subprocesses, fixing an isolation issue. See
    # https://groups.google.com/forum/#!topic/sage-packaging/YGOm8tkADrE
    ./patches/sphinx-docbuild-subprocesses.patch

    # After updating smypow to (https://github.com/sagemath/sage/issues/3360)
    # we can now set the cache dir to be within the .sage directory. This is
    # not strictly necessary, but keeps us from littering in the user's HOME.
    ./patches/sympow-cache.patch
=======
    # Fixes a potential race condition which can lead to transient doctest failures.
    ./patches/fix-ecl-race.patch

    # Not necessary since library location is set explicitly
    # https://trac.sagemath.org/ticket/27660#ticket
    ./patches/do-not-test-find-library.patch

    # Parallelize docubuild using subprocesses, fixing an isolation issue. See
    # https://groups.google.com/forum/#!topic/sage-packaging/YGOm8tkADrE
    ./patches/sphinx-docbuild-subprocesses.patch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # Since sage unfortunately does not release bugfix releases, packagers must
  # fix those bugs themselves. This is for critical bugfixes, where "critical"
  # == "causes (transient) doctest failures / somebody complained".
  bugfixPatches = [
<<<<<<< HEAD
    # Sage uses mixed integer programs (MIPs) to find edge disjoint
    # spanning trees. For some reason, aarch64 glpk takes much longer
    # than x86_64 glpk to solve such MIPs. Since the MIP formulation
    # has "numerous problems" and will be replaced by a polynomial
    # algorithm soon, disable this test for now.
    # https://github.com/sagemath/sage/issues/34575
    ./patches/disable-slow-glpk-test.patch
=======
    # To help debug the transient error in
    # https://trac.sagemath.org/ticket/23087 when it next occurs.
    ./patches/configurationpy-error-verbose.patch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  ];

  # Patches needed because of package updates. We could just pin the versions of
  # dependencies, but that would lead to rebuilds, confusion and the burdons of
  # maintaining multiple versions of dependencies. Instead we try to make sage
  # compatible with never dependency versions when possible. All these changes
  # should come from or be proposed to upstream. This list will probably never
  # be empty since dependencies update all the time.
  packageUpgradePatches = [
<<<<<<< HEAD
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

    # https://github.com/sagemath/sage/pull/36006, positively reviewed
    (fetchpatch {
      name = "gmp-6.3-upgrade.patch";
      url = "https://github.com/sagemath/sage/commit/d88bc3815c0901bfdeaa3e4a31107c084199f614.diff";
      sha256 = "sha256-dXaEwk2wXxmx02sCw4Vu9mF0ZrydhFD4LRwNAiQsPgM=";
    })
=======
    # After updating smypow to (https://trac.sagemath.org/ticket/3360) we can
    # now set the cache dir to be within the .sage directory. This is not
    # strictly necessary, but keeps us from littering in the user's HOME.
    ./patches/sympow-cache.patch

    # Upstream will wait until Sage 9.7 to upgrade to linbox 1.7 because it
    # does not support gcc 6. We can upgrade earlier.
    # https://trac.sagemath.org/ticket/32959
    ./patches/linbox-1.7-upgrade.patch

    # adapted from https://trac.sagemath.org/ticket/23712#comment:22
    ./patches/tachyon-renamed-focallength.patch

    # https://trac.sagemath.org/ticket/34391
    (fetchSageDiff {
      name = "gap-4.12-upgrade.patch";
      base = "9.8.beta7";
      rev = "dd4a17281adcda74e11f998ef519b6bd0dafb043";
      sha256 = "sha256-UQT9DO9xd5hh5RucvUkIm+rggPKu8bc1YaSI6LVYH98=";
    })

    # https://trac.sagemath.org/ticket/34701
    (fetchSageDiff {
      name = "libgap-fix-gc-crashes-on-aarch64.patch";
      base = "eb8cd42feb58963adba67599bf6e311e03424328"; # TODO: update when #34391 lands
      rev = "90acc7f1c13a80b8aa673469a2668feb9cd4207f";
      sha256 = "sha256-9BhQLFB3wUhiXRQsK9L+I62lSjvTfrqMNi7QUIQvH4U=";
    })

    # https://github.com/sagemath/sage/pull/35235
    (fetchpatch {
      name = "ipython-8.11-upgrade.patch";
      url = "https://github.com/sagemath/sage/commit/23471e2d242c4de8789d7b1fc8b07a4b1d1e595a.diff";
      sha256 = "sha256-wvH4BvDiaBv7jbOP8LvOE5Vs16Kcwz/C9jLpEMohzLQ=";
    })

    # positively reviewed
    (fetchpatch {
      name = "matplotlib-3.7.0-upgrade.patch";
      url = "https://github.com/sagemath/sage/pull/35177.diff";
      sha256 = "sha256-YdPnMsjXBm9ZRm6a8hH8rSynkrABjLoIzqwp3F/rKAw=";
    })

    # https://github.com/sagemath/sage/pull/35336, merged in 10.0.beta8
    (fetchpatch {
      name = "ipywidgets-8.0.5-upgrade.patch";
      url = "https://github.com/sagemath/sage/commit/7ab3e3aa81d47a35d09161b965bba8ab16fd5c9e.diff";
      sha256 = "sha256-WjdsPTui6uv92RerlV0mqltmLaxADvz+3aqSvxBFmfU=";
    })

    # https://github.com/sagemath/sage/pull/35499
    (fetchpatch {
      name = "ipywidgets-8.0.5-upgrade-part-deux.patch";
      url = "https://github.com/sagemath/sage/pull/35499.diff";
      sha256 = "sha256-uNCjLs9qrARTQNsq1+kTdvuV2A1M4xx5b1gWh5c55X0=";
    })

    # rebased from https://github.com/sagemath/sage/pull/34994, merged in sage 10.0.beta2
    ./patches/numpy-1.24-upgrade.patch

    # Sage uses mixed integer programs (MIPs) to find edge disjoint
    # spanning trees. For some reason, aarch64 glpk takes much longer
    # than x86_64 glpk to solve such MIPs. Since the MIP formulation
    # has "numerous problems" and will be replaced by a polynomial
    # algorithm soon, disable this test for now.
    # https://trac.sagemath.org/ticket/34575
    ./patches/disable-slow-glpk-test.patch
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
=======

    # src/doc/en/reference/spkg/conf.py expects index.rst in its directory,
    # a list of external packages in the sage distribution (build/pkgs)
    # generated by the bootstrap script (which we don't run).  this is not
    # relevant for other distributions, so remove it.
    rm src/doc/en/reference/spkg/conf.py
    sed -i "/spkg/d" src/doc/en/reference/index.rst

    # the bootstrap script also generates installation instructions for
    # arch, debian, fedora, cygwin and homebrew using data from build/pkgs.
    # we don't run the bootstrap script, so disable including the generated
    # files. docbuilding fails otherwise.
    sed -i "/literalinclude/d" src/doc/en/installation/source.rst
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  '';

  buildPhase = "# do nothing";

  installPhase = ''
    cp -r . "$out"
  '';
}
