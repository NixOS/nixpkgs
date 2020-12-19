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
  version = "9.2";
  pname = "sage-src";

  src = fetchFromGitHub {
    owner = "sagemath";
    repo = "sage";
    rev = version;
    sha256 = "103j8d5x6szl9fxaz0dvdi4y47q1af9h9y5hmjh2xayi62qmp5ql";
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

    # Sage's workaround to pretty print dicts (in
    # src/sage/doctest/forker.py:init_sage) runs too late (after
    # controller.load_environment(), which imports sage.all.*) to to
    # affect sage.sandpiles.Sandpile{Config,Divisor}'s pretty printer.
    # Due to the sandpiles module being lazily loaded, this only
    # affects the first run (subsequent runs read from an import cache
    # at ~/.sage/cache and are not affected), which is probably why
    # other distributions don't hit this bug. This breaks two sandpile
    # tests, so do the workaround a little bit earlier.
    # https://trac.sagemath.org/ticket/31053
    ./patches/register-pretty-printer-earlier.patch
  ];

  # Since sage unfortunately does not release bugfix releases, packagers must
  # fix those bugs themselves. This is for critical bugfixes, where "critical"
  # == "causes (transient) doctest failures / somebody complained".
  bugfixPatches = [
    # To help debug the transient error in
    # https://trac.sagemath.org/ticket/23087 when it next occurs.
    ./patches/configurationpy-error-verbose.patch

    # fix intermittent errors in Sage 9.2's psage.py (this patch is
    # already included in Sage 9.3): https://trac.sagemath.org/ticket/30730
    (fetchpatch {
      name = "fix-psage-is-locked.patch";
      url = "https://git.sagemath.org/sage.git/patch/?id=75df605f216ddc7b6ca719be942d666b241520e9";
      sha256 = "0g9pl1wbb3sgs26d3bvv70cpa77sfskylv4kd255y1794f1fgk4q";
    })

    # fix intermittent errors in sagespawn.pyx: https://trac.sagemath.org/ticket/31052
    ./patches/sagespawn-implicit-casting.patch
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
    # After updating smypow to (https://trac.sagemath.org/ticket/3360) we can
    # now set the cache dir to be withing the .sage directory. This is not
    # strictly necessary, but keeps us from littering in the user's HOME.
    ./patches/sympow-cache.patch

    # ignore a deprecation warning for usage of `cmp` in the attrs library in the doctests
    ./patches/ignore-cmp-deprecation.patch

    # adapt sage's Image class to pillow 8.0.1 (https://trac.sagemath.org/ticket/30971)
    ./patches/pillow-update.patch
  ];

  patches = nixPatches ++ bugfixPatches ++ packageUpgradePatches;

  postPatch = ''
    # make sure shebangs etc are fixed, but sage-python23 still works
    find . -type f -exec sed \
      -e 's/sage-python23/python3/g' \
      -i {} \;

    echo '#!${runtimeShell}
    python3 "$@"' > build/bin/sage-python23

    # Make sure sage can at least be imported without setting any environment
    # variables. It won't be close to feature complete though.
    sed -i \
      "s|var('SAGE_ROOT'.*|var('SAGE_ROOT', '$out')|" \
      src/sage/env.py

    # Do not use sage-env-config (generated by ./configure).
    # Instead variables are set manually.
    echo '# do nothing' >  src/bin/sage-env-config
  '';

  # Test src/doc/en/reference/spkg/conf.py will fail if
  # src/doc/en/reference/spkg/index.rst is not generated.  It is
  # generated by src/doc/bootstrap, so I've copied the relevant part
  # here. An alternative would be to create an empty
  # src/doc/en/reference/spkg/index.rst file.
  configurePhase = ''
    OUTPUT_DIR="src/doc/en/reference/spkg"
    mkdir -p "$OUTPUT_DIR"
    OUTPUT_INDEX="$OUTPUT_DIR"/index.rst
    cat > "$OUTPUT_INDEX" <<EOF

    External Packages
    =================

    .. toctree::
       :maxdepth: 1

    EOF
    for PKG_SCRIPTS in build/pkgs/*; do
        if [ -d "$PKG_SCRIPTS" ]; then
            PKG_BASE=$(basename "$PKG_SCRIPTS")
            if [ -f "$PKG_SCRIPTS"/SPKG.rst ]; then
                # Instead of just copying, we may want to call
                # a version of sage-spkg-info to format extra information.
                cp "$PKG_SCRIPTS"/SPKG.rst "$OUTPUT_DIR"/$PKG_BASE.rst
                echo >> "$OUTPUT_INDEX" "   $PKG_BASE"
            fi
        fi
    done
    cat >> "$OUTPUT_INDEX" <<EOF
    .. include:: ../footer.txt
    EOF
  '';

  buildPhase = "# do nothing";

  installPhase = ''
    cp -r . "$out"
  '';
}
