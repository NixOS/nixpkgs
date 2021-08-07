{ stdenv
, fetchFromGitHub
, fetchpatch
, runtimeShell
}:

# This file is responsible for fetching the sage source and adding necessary patches.
# It does not actually build anything, it just copies the patched sources to $out.
# This is done because multiple derivations rely on these sources and they should
# all get the same sources with the same patches applied.

let
  # Fetch a diff between `base` and `rev` on sage's git server.
  # Used to fetch trac tickets by setting the `base` to the last release and the
  # `rev` to the last commit of the ticket.
  fetchSageDiff = { base, name, rev, sha256, ...}@args: (
    fetchpatch ({
      inherit name sha256;

      # We used to use
      # "https://git.sagemath.org/sage.git/patch?id2=${base}&id=${rev}"
      # but the former way does not squash multiple patches together.
      url = "https://github.com/sagemath/sage/compare/${base}...${rev}.diff";

      # We don't care about sage's own build system (which builds all its dependencies).
      # Exclude build system changes to avoid conflicts.
      excludes = [ "build/*" ];
    } // builtins.removeAttrs args [ "rev" "base" "sha256" ])
  );
in
stdenv.mkDerivation rec {
  version = "9.3";
  pname = "sage-src";

  src = fetchFromGitHub {
    owner = "sagemath";
    repo = "sage";
    rev = version;
    sha256 = "sha256-l9DX8jcDdKA7GJ6xU+nBsmlZxrcZ9ZUAJju621ooBEo=";
  };

  # Patches needed because of particularities of nix or the way this is packaged.
  # The goal is to upstream all of them and get rid of this list.
  nixPatches = [
    # Make sure py2/py3 tests are only run when their expected context (all "sage"
    # tests) are also run. That is necessary to test dochtml individually. See
    # https://trac.sagemath.org/ticket/26110 for an upstream discussion.
    # TODO: Determine if it is still necessary.
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
  packageUpgradePatches = [
    # After updating smypow to (https://trac.sagemath.org/ticket/3360) we can
    # now set the cache dir to be withing the .sage directory. This is not
    # strictly necessary, but keeps us from littering in the user's HOME.
    ./patches/sympow-cache.patch

    # ignore a deprecation warning for usage of `cmp` in the attrs library in the doctests
    ./patches/ignore-cmp-deprecation.patch

    # remove use of matplotlib function deprecated in 3.4
    # https://trac.sagemath.org/ticket/31827
    (fetchSageDiff {
      base = "9.3";
      name = "remove-matplotlib-deprecated-function.patch";
      rev = "32b2bcaefddc4fa3d2aee6fa690ce1466cbb5948";
      sha256 = "sha256-SXcUGBMOoE9HpuBzgKC3P6cUmM5MiktXbe/7dVdrfWo=";
    })

    # pari 2.13 update
    # https://trac.sagemath.org/ticket/30801
    #
    # the last commit in that ticket is
    # c78b1470fccd915e2fa93f95f2fefba6220fb1f7, but commits after
    # 10a4531721d2700fd717e2b3a1364508ffd971c3 only deal with 32-bit
    # and post-26635 breakage, none of which is relevant to us. since
    # there are post-9.4.beta0 rebases after that, we just skip later
    # commits.
    (fetchSageDiff {
      base = "9.3";
      name = "pari-2.13.1.patch";
      rev = "10a4531721d2700fd717e2b3a1364508ffd971c3";
      sha256 = "sha256-gffWKK9CMREaNOb5zb63iZUgON4FvsPrMQNqe+5ZU9E=";
    })

    # sympy 1.8 update
    # https://trac.sagemath.org/ticket/31647
    (fetchSageDiff {
      base = "9.4.beta0";
      name = "sympy-1.8.patch";
      rev = "fa864b36e15696450c36d54215b1e68183b29d25";
      sha256 = "sha256-fj/9QEZlVF0fw9NpWflkTuBSKpGjCE6b96ECBgdn77o=";
    })

    # sphinx 4 update
    # https://trac.sagemath.org/ticket/31696
    (fetchSageDiff {
      base = "9.4.beta3";
      name = "sphinx-4.patch";
      rev = "bc84af8c795b7da433d2000afc3626ee65ba28b8";
      sha256 = "sha256-5Kvs9jarC8xRIU1rdmvIWxQLC25ehiTLJpg5skh8WNM=";
    })

    # eclib 20210625 update
    # https://trac.sagemath.org/ticket/31443
    (fetchSageDiff {
      base = "9.4.beta3";
      name = "eclib-20210625.patch";
      rev = "789550ca04c94acfb1e803251538996a34962038";
      sha256 = "sha256-VlyEn5hg3joG8t/GwiRfq9TzJ54AoHxLolsNQ3shc2c=";
    })
  ];

  patches = nixPatches ++ bugfixPatches ++ packageUpgradePatches;

  postPatch = ''
    # Make sure sage can at least be imported without setting any environment
    # variables. It won't be close to feature complete though.
    sed -i \
      "s|var(\"SAGE_ROOT\".*|var(\"SAGE_ROOT\", \"$out\")|" \
      src/sage/env.py

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
  '';

  buildPhase = "# do nothing";

  installPhase = ''
    cp -r . "$out"
  '';
}
