{ stdenv
, lib
, fetchurl
, makeWrapper
, readline
, gmp
, pari
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
    "gapdoc"
    "primgrp"
    "smallgrp"
    "transgrp"
  ];
  # packages autoloaded by default if available, and their dependencies
  autoloadedPackages = [
    "atlasrep"
    "autpgrp"
    "alnuth"
    "crisp"
    "ctbllib"
    "factint"
    "fga"
    "irredsol"
    "laguna"
    "polenta"
    "polycyclic"
    "resclasses"
    "sophus"
    "tomlib"
    "autodoc"  # dependency of atlasrep
    "io"       # used by atlasrep to fetch data from online sources
    "radiroot" # dependency of polenta
    "utils"    # dependency of atlasrep
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
  version = "4.12.2";

  src = fetchurl {
    url = "https://github.com/gap-system/gap/releases/download/v${version}/gap-${version}.tar.gz";
    sha256 = "sha256-ZyMIdF63iiIklO6N1nhu3VvDMUVvzGRWrAZL2yjVh6g=";
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

  propagatedBuildInputs = [
    pari # used at runtime by the alnuth package
  ];

  # "teststandard" is a superset of the tests run by "check". it takes ~20min
  # instead of ~1min. tests are run twice, once with all packages loaded and
  # once without.
  # installCheckTarget = "teststandard";

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
      "TESTGAPcore=gap --quitonbreak -b -q -r"
      "TESTGAPauto=gap --quitonbreak -b -q -r -m 100m -o 1g -x 80"
      "TESTGAP=gap --quitonbreak -b -q -r -m 100m -o 1g -x 80 -A"
    )
  '';

  postBuild = ''
    pushd pkg
    # failures are ignored unless --strict is set
    bash ../bin/BuildPackages.sh ${lib.optionalString (!keepAll) "--strict"}
    popd
  '';

  postInstall = ''
    # make install creates an empty pkg dir. since we run "make check" on
    # installCheckPhase to make sure the installed GAP finds its libraries, we
    # also install the tst dir. this is probably excessively cautious, see
    # https://github.com/NixOS/nixpkgs/pull/192548#discussion_r992824942
    rm -r "$out/share/gap/pkg"
    cp -ar pkg tst "$out/share/gap"

    makeWrapper "$out/lib/gap/gap" "$out/bin/gap" --add-flags "-l $out/share/gap"
  '';

  preFixup = ''
    # patchelf won't strip references to the build dir if it still exists
    rm -rf pkg
  '';

  meta = with lib; {
    description = "Computational discrete algebra system";
    # We are also grateful to ChrisJefferson for previous work on the package,
    # and to ChrisJefferson and fingolfin for help with GAP-related questions
    # from the upstream point of view.
    maintainers = teams.sage.members;
    platforms = platforms.all;
    # keeping all packages increases the package size considerably, which is
    # why a local build is preferable in that situation. The timeframe is
    # reasonable and that way the binary cache doesn't get overloaded.
    hydraPlatforms = lib.optionals (!keepAllPackages) meta.platforms;
    license = licenses.gpl2;
    homepage = "https://www.gap-system.org";
  };
}
