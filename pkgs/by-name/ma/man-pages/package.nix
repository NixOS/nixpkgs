{
  lib,
  stdenv,
  fetchurl,
  directoryListingUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "man-pages";
  version = "6.11";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/man-pages-${finalAttrs.version}.tar.xz";
    hash = "sha256-3aou2i6NKG++wiHRFfEtP/9dNsxQZs3+zI0koljVixk=";
  };

  dontBuild = true;
  enableParallelInstalling = true;

  makeFlags = [
    "-R"
    "VERSION=${finalAttrs.version}"
    "prefix=${placeholder "out"}"
  ];

  preConfigure = ''
    # If not provided externally, the makefile will attempt to determine the
    # date and time of the release from the Git repository log, which is not
    # available in the distributed tarball. We therefore supply it from
    # $SOURCE_DATE_EPOCH, which is based on the most recent modification time
    # of all source files. Cf.
    # nixpkgs/pkgs/build-support/setup-hooks/set-source-date-epoch-to-latest.sh
    export DISTDATE="$(date --utc --date="@$SOURCE_DATE_EPOCH")"
  '';

  passthru.updateScript = directoryListingUpdater {
    url = "https://www.kernel.org/pub/linux/docs/man-pages/";
  };

  meta = {
    description = "Linux development manual pages";
    homepage = "https://www.kernel.org/doc/man-pages/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    priority = 30; # if a package comes with its own man page, prefer it
  };
})
