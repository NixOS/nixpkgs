{ stdenv
, lib
, fetchurl
, fetchpatch
, makeWrapper
, readline
, gmp
, zlib
# one of
# - "minimal" (~400M):
#     Install the bare minimum of packages required by gap to start.
#     This is likely to break a lot of stuff. Do not expect upstream support with
#     this configuration.
# - "standard" (~700M):
#     Install the "standard packages" which gap autoloads by default. These
#     packages are effectively considered a part of gap.
# - "full" (~1.7G):
#     Install all available packages. This takes a lot of space.
, packageSet ? "standard"
# Kept for backwards compatibility. Overrides packageSet to "full".
, keepAllPackages ? false
}:
let
  # packages absolutely required for gap to start
  # `*` represents the version where applicable
  requiredPackages = [
    "GAPDoc-*"
    "primgrp-*"
    "SmallGrp-*"
    "transgrp"
  ];
  # packages autoloaded by default if available
  autoloadedPackages = [
    "atlasrep"
    "autpgrp-*"
    "alnuth-*"
    "crisp-*"
    "ctbllib"
    "FactInt-*"
    "fga"
    "irredsol-*"
    "laguna-*"
    "polenta-*"
    "polycyclic-*"
    "resclasses-*"
    "sophus-*"
    "tomlib-*"
  ];
  keepAll = keepAllPackages || (packageSet == "full");
  packagesToKeep = requiredPackages ++ lib.optionals (packageSet == "standard") autoloadedPackages;

  # Generate bash script that removes all packages from the `pkg` subdirectory
  # that are not on the whitelist. The whitelist consists of strings expected by
  # `find`'s `-name`.
  removeNonWhitelistedPkgs = whitelist: ''
    find pkg -type d -maxdepth 1 -mindepth 1 \
  '' + (lib.concatStringsSep "\n" (map (str: "-not -name '${str}' \\") whitelist)) + ''
    -exec echo "Removing package {}" \; \
    -exec rm -r '{}' \;
  '';
in
stdenv.mkDerivation rec {
  pname = "gap";
  # https://www.gap-system.org/Releases/
  version = "4.11.0";

  src = fetchurl {
    url = "https://files.gap-system.org/gap-${lib.versions.major version}.${lib.versions.minor version}/tar.bz2/gap-${version}.tar.bz2";
    sha256 = "sha256-vwcKENwqxgWT/mXfD4c9ctTWdQHobrJipva9SPyGhgI=";
  };

  # remove all non-essential packages (which take up a lot of space)
  preConfigure = lib.optionalString (!keepAll) (removeNonWhitelistedPkgs packagesToKeep) + ''
    patchShebangs .
  '';

  buildInputs = [
    readline
    gmp
    zlib
  ];

  nativeBuildInputs = [
    makeWrapper
  ];

  patches = [
    # Fix for locale specific tests causing issues. Already upstream.
    # Backport of https://github.com/gap-system/gap/pull/4022
    (fetchpatch {
      name = "remove-locale-specific-tests.patch";
      url = "https://github.com/gap-system/gap/commit/c18b0c4215b5212a2cc4f305e2d5b94ba716bee8.patch";
      sha256 = "sha256-De+T9Y7ewRT6plJrj2VR8axRvD/JCTYKOBWB7Bw0oq0=";
    })

    # fixes aarch64 gc crashes: https://github.com/gap-system/gap/pull/3965
    (fetchpatch {
      name = "mark-genstackfuncbags-as-noinline.patch";
      url = "https://github.com/gap-system/gap/commit/f0a8f49ff8dad0a5fa77253d45457c6f40f96778.patch";
      sha256 = "sha256-GU9tOP1stX2vn8m8kXOBupEpxIYArA76ibKL8eLn0MY=";
    })
  ];

  # "teststandard" is a superset of testinstall. It takes ~1h instead of ~1min.
  # tests are run twice, once with all packages loaded and once without
  # checkTarget = "teststandard";

  doInstallCheck = true;
  installCheckTarget = "check";

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

  postBuild = ''
    pushd pkg
    bash ../bin/BuildPackages.sh
    popd
  '';

  installTargets = [
    "install-libgap"
    "install-headers"
  ];

  # full `make install` is not yet implemented, just for libgap and headers
  postInstall = ''
    # Install config.h, which is not currently handled by `make install-headers`
    cp gen/config.h "$out/include/gap"

    mkdir -p "$out/bin" "$out/share/gap/"

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
      timokau
    ];
    platforms = platforms.all;
    broken = stdenv.isDarwin;
    # keeping all packages increases the package size considerably, which is
    # why a local build is preferable in that situation. The timeframe is
    # reasonable and that way the binary cache doesn't get overloaded.
    hydraPlatforms = lib.optionals (!keepAllPackages) meta.platforms;
    license = licenses.gpl2;
    homepage = "https://www.gap-system.org";
  };
}
