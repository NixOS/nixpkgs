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
      url = "https://git.sagemath.org/sage.git/patch?id2=${base}&id=${rev}";
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

    # sphinx 3.5 pretty-prints code slightly differently than sphinx
    # 3.1--3.3. a similar patch is available at the sphinx 4 ticket
    # (https://trac.sagemath.org/ticket/31696), but sphinx 3.5 uses
    # <code> tags while sphinx 4 uses <span> tags so we cannot just
    # import the patch from trac.
    ./patches/sphinx-3.5-code-output.patch

    # remove use of matplotlib function deprecated in 3.4
    # https://trac.sagemath.org/ticket/31827
    (fetchSageDiff {
      base = "9.3";
      name = "remove-matplotlib-deprecated-function.patch";
      rev = "32b2bcaefddc4fa3d2aee6fa690ce1466cbb5948";
      sha256 = "sha256-SXcUGBMOoE9HpuBzgKC3P6cUmM5MiktXbe/7dVdrfWo=";
    })

    # https://trac.sagemath.org/ticket/30801. this patch has
    # positive_review but has not been merged upstream yet, so we
    # don't use fetchSageDiff because it returns a file that contains
    # each commit as a separate patch instead of a single diff, and
    # some commits from the pari update branch are already in 9.3.rc5
    # (auto-resolvable merge conflicts).
    (fetchpatch {
      name = "pari-2.13.1.patch";
      url = "https://github.com/sagemath/sagetrac-mirror/compare/d6c5cd9be78cc448ee4c54bac93385b1244a234c...10a4531721d2700fd717e2b3a1364508ffd971c3.diff";
      sha256 = "sha256-zMjRMEReoiTvmt+vvV0Ij1jtyLSLwSXBEVXqgvmq1D4=";
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
