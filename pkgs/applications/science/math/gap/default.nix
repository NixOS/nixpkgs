{ stdenv
, fetchurl
, fetchpatch
, m4
, gmp
# don't remove any packages -- results in a ~1.3G size increase
# see https://github.com/NixOS/nixpkgs/pull/38754 for a discussion
, keepAllPackages ? true
}:

stdenv.mkDerivation rec {
  pname = "gap";
  # https://www.gap-system.org/Releases/
  # newer versions (4.9.0) are available, but still considered beta (https://github.com/gap-system/gap/wiki/GAP-4.9-release-notes)
  version = "4r8p10";
  pkgVer = "2018_01_15-13_02";
  name = "${pname}-${version}";

  src = let
    # 4r8p10 -> 48
    majorminor = stdenv.lib.replaceStrings ["r"] [""] (
      builtins.head (stdenv.lib.splitString "p" version) # 4r8p10 -> 4r8
    );
  in
    fetchurl {
    url = "https://www.gap-system.org/pub/gap/gap${majorminor}/tar.bz2/gap${version}_${pkgVer}.tar.bz2";
    sha256 = "0wzfdjnn6sfiaizbk5c7x44rhbfayis4lf57qbqqg84c7dqlwr6f";
  };

  # remove all non-essential packages (which take up a lot of space)
  preConfigure = stdenv.lib.optionalString (!keepAllPackages) ''
    find pkg -type d -maxdepth 1 -mindepth 1 \
       -not -name 'GAPDoc-*' \
       -not -name 'autpgrp*' \
       -exec echo "Removing package {}" \; \
       -exec rm -r {} \;
  '';

  configureFlags = [ "--with-gmp=system" ];
  buildInputs = [ m4 gmp ];

  patches = [
    #  fix infinite loop in writeandcheck() when writing an error message fails.
    (fetchpatch {
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/gap/patches/writeandcheck.patch?id=07d6c37d18811e2b377a9689790a7c5e24da16ba";
      sha256 = "1r1511x4kc2i2mbdq1b61rb6p3misvkf1v5qy3z6fmn6vqwziaz1";
    })
  ];

  doCheck = true;
  checkTarget = "testinstall";
  # "teststandard" is a superset of testinstall. It takes ~1h instead of ~1min.
  # tests are run twice, once with all packages loaded and once without
  # checkTarget = "teststandard";

  preCheck = ''
    # gap tests check that the home directory exists
    export HOME="$TMP/gap-home"
    mkdir -p "$HOME"
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

    cp -r . "$out/share/gap/build-dir"

    sed -e "/GAP_DIR=/aGAP_DIR='$out/share/gap/build-dir/'" -i "$out/share/gap/build-dir/bin/gap.sh"

    ln -s "$out/share/gap/build-dir/bin/gap.sh" "$out/bin/gap"
  '';

  meta = with stdenv.lib; {
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
    hydraPlatforms = stdenv.lib.optionals (!keepAllPackages) meta.platforms;
    license = licenses.gpl2;
    homepage = http://gap-system.org/;
  };
}
