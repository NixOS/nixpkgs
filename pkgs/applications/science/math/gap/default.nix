{ stdenv
, lib
, fetchurl
, fetchpatch
, makeWrapper
, m4
, gmp
# don't remove any packages -- results in a ~1.3G size increase
# see https://github.com/NixOS/nixpkgs/pull/38754 for a discussion
, keepAllPackages ? true
}:

stdenv.mkDerivation rec {
  pname = "gap";
  # https://www.gap-system.org/Releases/
  version = "4.10.0";

  src = fetchurl {
    url = "https://www.gap-system.org/pub/gap/gap-${lib.versions.major version}.${lib.versions.minor version}/tar.bz2/gap-${version}.tar.bz2";
    sha256 = "1dmb8v4p7j1nnf7sx8sg54b49yln36bi9acwp7w1d3a1nxj17ird";
  };

  # remove all non-essential packages (which take up a lot of space)
  preConfigure = ''
    patchShebangs .
  '' + lib.optionalString (!keepAllPackages) ''
    find pkg -type d -maxdepth 1 -mindepth 1 \
       -not -name 'GAPDoc-*' \
       -not -name 'autpgrp*' \
       -exec echo "Removing package {}" \; \
       -exec rm -r {} \;
  '';

  configureFlags = [ "--with-gmp=system" ];

  buildInputs = [
    m4
    gmp
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  patches = [
    # bugfix: https://github.com/gap-system/gap/pull/3102
    (fetchpatch {
      name = "fix-infinite-loop-in-writeandcheck.patch";
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/gap/patches/0001-a-version-of-the-writeandcheck.patch-from-Sage-that-.patch?id=5e61d7b6a0da3aa53d8176fa1fb9353cc559b098";
      sha256 = "1zkv8bbiw3jdn54sqqvfkdkfsd7jxzq0bazwsa14g4sh2265d28j";
    })

    # needed for libgap (sage): https://github.com/gap-system/gap/pull/3043
    (fetchpatch {
      name = "add-error-messages-helper.patch";
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/gap/patches/0002-kernel-add-helper-function-for-writing-error-message.patch?id=5e61d7b6a0da3aa53d8176fa1fb9353cc559b098";
      sha256 = "0c4ry5znb6hwwp8ld6k62yw8w6cqldflw3x49bbzizbmipfpidh5";
    })

    # needed for libgap (sage): https://github.com/gap-system/gap/pull/3096
    (fetchpatch {
      name = "gap-enter.patch";
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/gap/patches/0003-Prototype-for-GAP_Enter-Leave-macros-to-bracket-use-.patch?id=5e61d7b6a0da3aa53d8176fa1fb9353cc559b098";
      sha256 = "12fg8mb8rm6khsz1r4k3k26jrkx4q1rv13hcrfnlhn0m7iikvc3q";
    })
  ];

  # "teststandard" is a superset of testinstall. It takes ~1h instead of ~1min.
  # tests are run twice, once with all packages loaded and once without
  # checkTarget = "teststandard";

  doInstallCheck = true;
  installCheckTarget = "testinstall";

  preInstallCheck = ''
    # gap tests check that the home directory exists
    export HOME="$TMP/gap-home"
    mkdir -p "$HOME"

    # make sure gap is in PATH
    export PATH="$out/bin:$PATH"

    # make sure we don't accidentally use the wrong gap binary
    rm -r bin

    # like the defaults the Makefile, but use gap from PATH instead of the
    # one from builddir
    installCheckFlagsArray+=(
      "TESTGAP=gap --quitonbreak -b -m 100m -o 1g -q -x 80 -r -A"
      "TESTGAPauto=gap --quitonbreak -b -m 100m -o 1g -q -x 80 -r"
    )
  '';

  postCheck = ''
    # The testsuite doesn't exit with a non-zero exit code on failure.
    # It leaves its logs in dev/log however.

    # grep for error messages
    if grep ^##### dev/log/*; then
        exit 1
    fi
  '';

  postBuild = ''
    pushd pkg
    bash ../bin/BuildPackages.sh
    popd
  '';

  installPhase = ''
    mkdir -p "$out/bin" "$out/share/gap/"

    mkdir -p "$out/share/gap"
    echo "Copying files to target directory"
    cp -ar . "$out/share/gap/build-dir"

    makeWrapper "$out/share/gap/build-dir/bin/gap.sh" "$out/bin/gap" \
      --set GAP_DIR $out/share/gap/build-dir
  '';

  preFixup = ''
    # patchelf won't strip references to the build dir if it still exists
    rm -rf pkg
  '';

  meta = with lib; {
    description = "Computational discrete algebra system";
    maintainers = with maintainers;
    [
      raskin
      chrisjefferson
    ];
    platforms = platforms.all;
    # keeping all packages increases the package size considerably, wchich
    # is why a local build is preferable in that situation. The timeframe
    # is reasonable and that way the binary cache doesn't get overloaded.
    hydraPlatforms = lib.optionals (!keepAllPackages) meta.platforms;
    license = licenses.gpl2;
    homepage = http://gap-system.org/;
  };
}
