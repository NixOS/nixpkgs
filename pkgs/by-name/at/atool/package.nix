{
  lib,
  stdenv,
  fetchurl,
  perl,
  bash,
  makeDesktopItem,
  copyDesktopItems,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "atool";
  version = "0.39.0";

  src = fetchurl {
    url = "mirror://savannah/atool/atool-${finalAttrs.version}.tar.gz";
    sha256 = "aaf60095884abb872e25f8e919a8a63d0dabaeca46faeba87d12812d6efc703b";
  };

  buildInputs = [ perl ];
  nativeBuildInputs = [ copyDesktopItems ];
  configureScript = "${bash}/bin/bash configure";

  desktopItems = [
    (makeDesktopItem {
      name = "aunpack";
      desktopName = "Aunpack";
      exec = "atool -x %f";
      terminal = true;
      noDisplay = true;
      mimeTypes = [
        "application/gzip"
        "application/x-7z-compressed"
        "application/x-bzip2"
        "application/x-compressed-tar"
        "application/x-cpio"
        "application/x-gtar"
        "application/x-lha"
        "application/x-lzop"
        "application/x-tar"
        "application/x-xz-compressed-tar"
        "application/zip"
        "application/x-rar"
      ];
    })
  ];

  meta = {
    homepage = "https://www.nongnu.org/atool";
    description = "Archive command line helper";
    platforms = lib.platforms.unix;
    license = lib.licenses.gpl3;
    mainProgram = "atool";
  };
})
