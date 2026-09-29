{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mlocate";
  version = "0.26";

  src = fetchurl {
    url = "https://releases.pagure.org/mlocate/mlocate-${finalAttrs.version}.tar.xz";
    hash = "sha256-MGPfef4Zj7lhjhgMVLrzEFsz2I/mAv8thXCq+UTxJj4=";
  };

  makeFlags = [
    "dbfile=/var/cache/locatedb"
  ];

  meta = {
    description = "Utility to index and quickly search for files";
    homepage = "https://pagure.io/mlocate";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.linux;
    maintainers = [ ];
  };
})
