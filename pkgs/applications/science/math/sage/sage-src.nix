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

    # Register sorted dict pprinter earlier (https://trac.sagemath.org/ticket/31053)
    (fetchSageDiff {
      base = "9.3.beta4";
      name = "register-pretty-printer-earlier.patch";
      rev = "d658230ce06ca19f4a3b3a4576297ee82f2d2151";
      sha256 = "sha256-9mPUV7K5PoLDH2vVaYaOfvDLDpmxU0Aj7m/eaXYotDs=";
    })
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
    (fetchSageDiff {
      base = "9.2.rc2";
      name = "fix-psage-is-locked.patch";
      rev = "75df605f216ddc7b6ca719be942d666b241520e9";
      sha256 = "0g9pl1wbb3sgs26d3bvv70cpa77sfskylv4kd255y1794f1fgk4q";
    })

    # fix intermittent errors in sagespawn.pyx: https://trac.sagemath.org/ticket/31052
    (fetchSageDiff {
      base = "9.2";
      name = "sagespawn-implicit-casting.patch";
      rev = "2959ac792ebd6107fe87c9af1541083de5ba02d6";
      sha256 = "sha256-bWIpEGir9Kawak5CJegBMNcHm/CqhWmdru+emeSsvO0=";
    })
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

    # adapt sage's Image class to pillow 8.0.1 (https://trac.sagemath.org/ticket/30971)
    (fetchSageDiff {
      base = "9.3.beta2";
      name = "pillow-8.0.1-update.patch";
      rev = "f05f2d0aac9c4b5abe68105cee2cc7f2c8461847";
      sha256 = "sha256-uY2UlgSd5hhOUUukB4Xc3Gjy0/e7p/qyq9jdvz10IOs=";
    })

    # don't use deprecated numpy type aliases (https://trac.sagemath.org/ticket/31364)
    (fetchSageDiff {
      base = "9.3.beta7";
      name = "dont-use-deprecated-numpy-type-aliases.patch";
      rev = "dfdef60515d4a4269e82d91280f76a7fdf10bf97";
      sha256 = "sha256-77/3LkT5J7DQN8IPlGJKB6ZcJPaF7xwje06JNns+0AE=";
    })

    # fix test output with sympy 1.7 (https://trac.sagemath.org/ticket/30985)
    ./patches/sympy-1.7-update.patch

    # workaround until we use sage's fork of threejs, which contains a "version" file
    ./patches/dont-grep-threejs-version-from-minified-js.patch

    # updated eclib output has punctuation changes and tidier whitespace
    ./patches/eclib-20210223-test-formatting.patch

    # upgrade arb to 2.18.1 (https://trac.sagemath.org/ticket/28623)
    (fetchSageDiff {
      base = "9.3.beta3";
      name = "arb-2.18.1-update.patch";
      rev = "0c9c4ed35c2eaf34ae0d19387c07b7f460e4abce";
      sha256 = "sha256-CjOJIsyyVCziAfvE6pWSihPO35IZMcY2/taXAsqhPLY=";
    })

    # giac 1.6.0-47 update (https://trac.sagemath.org/ticket/30537)
    (fetchSageDiff {
      base = "9.3.beta7";
      name = "giac-1.6.0-47-update.patch";
      rev = "f05720bf63dfaf33a4e3b6d3ed2c2c0ec46b5d31";
      sha256 = "sha256-gDUq+84eXd5GxLBWUSI61GMJpBF2KX4LBVOt3mS1NF8=";
    })

    # Make gcd/lcm interact better with pari and gmpy2 (https://trac.sagemath.org/ticket/30849)
    # needed for pari 2.13.1 update, which we will do in the future
    (fetchSageDiff {
      base = "9.3.beta0";
      name = "make-gcd-lcm-interact-better-with-pari-and-gmpy2.patch";
      rev = "75c1516f0abb9e6f8c335e38e4031f6ef674ed30";
      sha256 = "sha256-RukkieIZcXNrju904H2oyGKdtpdE+9vNzvyjN2IBNg0=";
    })
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
