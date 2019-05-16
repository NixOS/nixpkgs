{ stdenv
, lib
, fetchurl
, fetchpatch
, makeWrapper
, m4
, gmp
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
  standardPackages = requiredPackages ++ autoloadedPackages;
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
  version = "4.10.1";

  src = fetchurl {
    url = "https://www.gap-system.org/pub/gap/gap-${lib.versions.major version}.${lib.versions.minor version}/tar.bz2/gap-${version}.tar.bz2";
    sha256 = "136s0zvhcw41fshj5zgsrjcy2kd58cdh2m3ddp5rdizi4rx54f10";
  };

  # remove all non-essential packages (which take up a lot of space)
  preConfigure = lib.optionalString (!keepAll) (removeNonWhitelistedPkgs packagesToKeep) + ''
    patchShebangs .
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
    # https://github.com/gap-system/gap/pull/3294
    (fetchpatch {
      name = "add-make-install-targets.patch";
      url = "https://github.com/gap-system/gap/commit/3361c172e6c5ff3bb3f01ba9d6f1dd4ad42cea80.patch";
      sha256 = "1kwp9qnfvmlbpf1c3rs6j5m2jz22rj7a4hb5x1gj9vkpiyn5pdyj";
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

  installTargets = [
    "install-libgap"
    "install-headers"
  ];

  # full `make install` is not yet implemented, just for libgap and headers
  postInstall = ''
    # Install config.h, which is not currently handled by `make install-headers`
    cp gen/config.h "$out/include/gap"

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
      timokau
    ];
    platforms = platforms.all;
    broken = stdenv.isDarwin;
    # keeping all packages increases the package size considerably, wchich
    # is why a local build is preferable in that situation. The timeframe
    # is reasonable and that way the binary cache doesn't get overloaded.
    hydraPlatforms = lib.optionals (!keepAllPackages) meta.platforms;
    license = licenses.gpl2;
    homepage = http://gap-system.org/;
  };
}
