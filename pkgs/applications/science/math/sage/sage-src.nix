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
  version = "9.5";
  pname = "sage-src";

  src = fetchFromGitHub {
    owner = "sagemath";
    repo = "sage";
    rev = version;
    sha256 = "sha256-uOsLpsGpcIGs8Xr82X82MElnTB2E908gytyNJ8WVD5w=";
  };

  # Patches needed because of particularities of nix or the way this is packaged.
  # The goal is to upstream all of them and get rid of this list.
  nixPatches = [
    # Since https://trac.sagemath.org/ticket/32174, some external features are
    # marked as "safe" and get auto-detected, in which case the corresponding
    # optional tests are executed. We disable auto-detection of safe features if
    # we are doctesting with an "--optional" argument which does not include
    # "sage", because tests from autodetected features expect context provided
    # by running basic sage tests. This is necessary to test sagemath_doc_html
    # separately. See https://trac.sagemath.org/ticket/26110 for a related
    # upstream discussion (from the time when Sage still had optional py2/py3
    # tags).
    ./patches/Only-test-external-software-when-all-of-sage-is.patch

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

    # Upstream will wait until Sage 9.7 to upgrade to linbox 1.7 because it
    # does not support gcc 6. We can upgrade earlier.
    # https://trac.sagemath.org/ticket/32959
    ./patches/linbox-1.7-upgrade.patch

    # https://trac.sagemath.org/ticket/33170
    (fetchSageDiff {
      base = "9.6.beta5";
      name = "ipython-8.1-update.patch";
      rev = "4d2b53f1541375861310af3a7f7109c1c2ed475d";
      sha256 = "sha256-ELda/VBzsQH7NdFas69fQ35QPUoJCeLx/gxT1j7qGR8=";
    })

    # https://trac.sagemath.org/ticket/32968
    (fetchSageDiff {
      base = "9.5";
      name = "sphinx-4.3-update.patch";
      rev = "fc84f82f52b6f05f512cb359ec7c100f93cf8841";
      sha256 = "sha256-bBbfdcnw/9LUOlY8rHJRbFJEdMXK4shosqTNaobTS1Q=";
    })

    # https://trac.sagemath.org/ticket/33189
    (fetchSageDiff {
      base = "9.5";
      name = "arb-2.22-update.patch";
      rev = "53532ddd4e2dc92469c1590ebf0c40f8f69bf579";
      sha256 = "sha256-6SoSBvIlqvNwZV3jTB6uPdUtaWIOeNmddi2poK/WvGs=";
    })

    # TODO: This will not be necessary when Sphinx 4.4.1 is released,
    # since some warnings introduced in 4.4.0 will be disabled by then
    # (https://github.com/sphinx-doc/sphinx/pull/10126).
    # https://trac.sagemath.org/ticket/33272
    (fetchSageDiff {
      base = "9.5";
      name = "sphinx-4.4-warnings.patch";
      rev = "97d7958bed441cf2ccc714d88f83d3a8426bc085";
      sha256 = "sha256-y1STE0oxswnijGCsBw8eHWWqpmT1XMznIfA0vvX9pFA=";
    })

    # adapted from https://trac.sagemath.org/ticket/23712#comment:22
    ./patches/tachyon-renamed-focallength.patch

    # https://trac.sagemath.org/ticket/33336
    (fetchSageDiff {
      base = "9.6.beta2";
      name = "scipy-1.8-update.patch";
      rev = "9c8235e44ffb509efa8a3ca6cdb55154e2b5066d";
      sha256 = "sha256-bfc4ljNOxVnhlmxIuNbjbKl4vJXYq2tlF3Z8bbC8PWw=";
    })

    # https://trac.sagemath.org/ticket/33495
    (fetchSageDiff {
      base = "9.6.beta5";
      name = "networkx-2.7-update.patch";
      rev = "8452003846a7303100847d8d0ed642fc642c11d6";
      sha256 = "sha256-A/XMouPlc2sjFp30L+56fBGJXydS2EtzfPOV98FCDqI=";
    })

    # https://trac.sagemath.org/ticket/33226
    (fetchSageDiff {
      base = "9.6.beta0";
      name = "giac-1.7.0-45-update.patch";
      rev = "33ea2adf01e9e2ce9f1e33779f0b1ac0d9d1989c";
      sha256 = "sha256-DOyxahf3+IaYdkgmAReNDCorRzMgO8+yiVrJ5TW1km0=";
    })

    # https://trac.sagemath.org/ticket/33398
    (fetchSageDiff {
      base = "9.6.beta4";
      name = "sympy-1.10-update.patch";
      rev = "6b7c3a28656180e42163dc10f7b4a571b93e5f27";
      sha256 = "sha256-fnUyM2yjHkCykKRfzQQ4glcUYmCS/fYzDzmCf0nuebk=";
      # The patch contains a whitespace change to a file that didn't exist in Sage 9.5.
      excludes = [ "build/*" "src/sage/manifolds/vector_bundle_fiber_element.py" ];
    })

    # docutils 0.18.1 now triggers Sphinx warnings. tolerate them for
    # now, because patching Sphinx is not feasible.
    # https://github.com/sphinx-doc/sphinx/issues/9777#issuecomment-1104481271
    ./patches/docutils-0.18.1-deprecation.patch
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
