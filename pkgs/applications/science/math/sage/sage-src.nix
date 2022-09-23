{ stdenv
, fetchFromGitHub
, fetchpatch
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
  version = "9.7";
  pname = "sage-src";

  src = fetchFromGitHub {
    owner = "sagemath";
    repo = "sage";
    rev = version;
    sha256 = "sha256-MYpCp18wqKwCa+tcJ7He14p1FXDlVm1vubQqQS9g3LY=";
  };

  # Patches needed because of particularities of nix or the way this is packaged.
  # The goal is to upstream all of them and get rid of this list.
  nixPatches = [
    # Fixes a potential race condition which can lead to transient doctest failures.
    ./patches/fix-ecl-race.patch

    # Not necessary since library location is set explicitly
    # https://trac.sagemath.org/ticket/27660#ticket
    ./patches/do-not-test-find-library.patch

    # Parallelize docubuild using subprocesses, fixing an isolation issue. See
    # https://groups.google.com/forum/#!topic/sage-packaging/YGOm8tkADrE
    ./patches/sphinx-docbuild-subprocesses.patch

    # Docbuilding copies files from the Nix store and expects them to be writable.
    # Remove when https://github.com/matplotlib/matplotlib/pull/23805 lands.
    ./patches/sphinx-fix-matplotlib-css-perms.patch
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

    # adapted from https://trac.sagemath.org/ticket/23712#comment:22
    ./patches/tachyon-renamed-focallength.patch

    # https://trac.sagemath.org/ticket/34118
    (fetchSageDiff {
      name = "sympy-1.11-upgrade.patch";
      base = "9.7";
      rev = "52815744bde2b682245b6f985a112f7cb8666056";
      sha256 = "sha256-gv6z6JkQ6S6oCJQNkVgcPVvzlplyvR1nC7pWmcUiSc0=";
    })

    # https://trac.sagemath.org/ticket/34460
    (fetchSageDiff {
      name = "ipywidgets-8-upgrade.patch";
      base = "9.7";
      rev = "2816dbacb342398a23bb3099e20c92c8020ab0fa";
      sha256 = "sha256-tCOsMxXwPkRg3FJGVvTqDzlWdra78UfDY6nci0Nr9GI=";
    })

    # https://trac.sagemath.org/ticket/34391
    (fetchSageDiff {
      name = "gap-4.12-upgrade.patch";
      base = "9.8.beta2";
      rev = "eb8cd42feb58963adba67599bf6e311e03424328";
      sha256 = "sha256-0dKewOZe2n3PqSdxCJt18FkqwTdrD0VA5MXAMiTW8Tw=";
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
