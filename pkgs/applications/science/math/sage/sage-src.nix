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
  fetchSageDiff = { base, name, rev, sha256, squashed ? false, ...}@args: (
    fetchpatch ({
      inherit name sha256;

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

      # We don't care about sage's own build system (which builds all its dependencies).
      # Exclude build system changes to avoid conflicts.
      excludes = [ "build/*" ];
    } // builtins.removeAttrs args [ "rev" "base" "sha256" "squashed" ])
  );
in
stdenv.mkDerivation rec {
  version = "9.4";
  pname = "sage-src";

  src = fetchFromGitHub {
    owner = "sagemath";
    repo = "sage";
    rev = version;
    sha256 = "sha256-jqkr4meG02KbTCMsGvyr1UbosS4ZuUJhPXU/InuS+9A=";
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
    # now set the cache dir to be within the .sage directory. This is not
    # strictly necessary, but keeps us from littering in the user's HOME.
    ./patches/sympow-cache.patch

    # fonttools 4.26.2, used by matplotlib, uses deprecated methods internally.
    # This is fixed in fonttools 4.27.0, but since fonttools is a dependency of
    # 2000+ packages and DeprecationWarnings are hidden almost everywhere by
    # default (not on Sage's doctest harness, though), it doesn't make sense to
    # backport the fix (see https://github.com/NixOS/nixpkgs/pull/151415).
    # Let's just assume warnings are expected until we update to 4.27.0.
    ./patches/fonttools-deprecation-warnings.patch

    # https://trac.sagemath.org/ticket/32305
    (fetchSageDiff {
      base = "9.4";
      name = "networkx-2.6-upgrade.patch";
      rev = "9808325853ba9eb035115e5b056305a1c9d362a0";
      sha256 = "sha256-gJSqycCtbAVr5qnVEbHFUvIuTOvaxFIeffpzd6nH4DE=";
    })

    # https://trac.sagemath.org/ticket/32420
    (fetchSageDiff {
      base = "9.5.beta2";
      name = "sympy-1.9-update.patch";
      rev = "beed4e16aff32e47d0c3b1c58cb1e2f4c38590f8";
      sha256 = "sha256-3eJPfWfCrCAQ5filIn7FbzjRQeO9QyTIVl/HyRuqFtE=";
    })

    # https://trac.sagemath.org/ticket/32567
    (fetchSageDiff {
      base = "9.5.beta2";
      name = "arb-2.21.0-update.patch";
      rev = "eb3304dd521a3d5a9334e747a08e234bbf16b4eb";
      sha256 = "sha256-XDkaY4VQGyESXI6zuD7nCNzyQOl/fmBFvAESH9+RRvk=";
    })

    # https://trac.sagemath.org/ticket/32797
    (fetchSageDiff {
      base = "9.5.beta7";
      name = "pari-2.13.3-update.patch";
      rev = "f5f7a86908daf60b25e66e6a189c51ada7e0a732";
      sha256 = "sha256-H/caGx3q4KcdsyGe+ojV9bUTQ5y0siqM+QHgDbeEnbw=";
    })

    # https://trac.sagemath.org/ticket/32909
    (fetchSageDiff {
      base = "9.5.beta7";
      name = "matplotlib-3.5-deprecation-warnings.patch";
      rev = "a5127dc56fdf5c2e82f6bc781cfe78dbd04e97b7";
      sha256 = "sha256-p23qUu9mgEUbdbX6cy7ArxZAtpcFjCKbgyxN4jWvj1o=";
    })

    # https://trac.sagemath.org/ticket/32968
    (fetchSageDiff {
      base = "9.5.beta8";
      name = "sphinx-4.3-update.patch";
      rev = "fc84f82f52b6f05f512cb359ec7c100f93cf8841";
      sha256 = "sha256-bBbfdcnw/9LUOlY8rHJRbFJEdMXK4shosqTNaobTS1Q=";
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
