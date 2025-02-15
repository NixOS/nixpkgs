{
  lib,
  stdenv,
  fetchurl,
  directoryListingUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "man-pages";
  version = "6.9.1";

  src = fetchurl {
    url = "mirror://kernel/linux/docs/man-pages/${finalAttrs.pname}-${finalAttrs.version}.tar.xz";
    hash = "sha256-4jy6wp8RC6Vx8NqFI+edNzaRRm7X8qMTAXIYF9NFML0=";
  };

  makeFlags = [
    "prefix=${placeholder "out"}"
  ];

  dontBuild = true;

  outputDocdev = "out";

  enableParallelInstalling = true;

  postInstall = ''
    # The manpath executable looks up manpages from PATH. And this package won't
    # appear in PATH unless it has a /bin folder. Without the change
    # 'nix-shell -p man-pages' does not pull in the search paths.
    # See 'man 5 manpath' for the lookup order.
    mkdir -p $out/bin
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
