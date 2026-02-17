{
  fetchurl,
  lib,
  stdenv,
  zstd,
  directoryListingUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "diffstat";
  version = "1.68";

  src = fetchurl {
    urls = [
      "https://invisible-island.net/archives/diffstat/diffstat-${finalAttrs.version}.tgz"
      "https://invisible-mirror.net/archives/diffstat/diffstat-${finalAttrs.version}.tgz"
    ];
    hash = "sha256-ifkpSorHT8728bmsQI9D6+340gjj7+C5m0rMFtxlgsc=";
  };

  buildInputs = [ zstd ];

  passthru.updateScript = directoryListingUpdater {
    url = "https://invisible-island.net/archives/diffstat/";
  };

  meta = {
    description = "Read output of diff and display a histogram of the changes";
    mainProgram = "diffstat";
    longDescription = ''
      diffstat reads the output of diff and displays a histogram of the
      insertions, deletions, and modifications per-file. It is useful for
      reviewing large, complex patch files.
    '';
    homepage = "https://invisible-island.net/diffstat/";
    license = lib.licenses.mit;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.bjornfor ];
  };
})
