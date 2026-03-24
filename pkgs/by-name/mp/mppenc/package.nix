{
  lib,
  stdenv,
  fetchurl,
  fetchpatch,
  cmake,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "mppenc";
  version = "1.16";

  src = fetchurl {
    url = "https://files.musepack.net/source/mppenc-${finalAttrs.version}.tar.bz2";
    hash = "sha256-+QeBhWynts4exwMzIfrbzQT+Jk0DScILSa0F98smVa0=";
  };

  nativeBuildInputs = [ cmake ];

  patches = [
    (fetchpatch {
      url = "https://salsa.debian.org/multimedia-team/mppenc/-/raw/c4106cab41261d6228e054a09272d662206c9fe5/debian/patches/kfreebsd-gnu_ftbfs.diff";
      hash = "sha256-vM9KcS8y0ad3zOSpzqeBRVb2XYwDpqfkhzccpHqoBD8=";
    })
    (fetchpatch {
      url = "https://salsa.debian.org/multimedia-team/mppenc/-/raw/a8e9ac3e110db50f8048f7cc54bace7a0110ea2e/debian/patches/cmake-4.patch";
      hash = "sha256-zCDZBQ3jFROVKu+3LYkLj6mAqHBceJvMWs/A7kPGnYY=";
    })
  ];

  meta = {
    description = "Musepack lossy audio codec encoder";
    homepage = "https://www.musepack.net";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [
      Renna42
    ];
    mainProgram = "mppenc";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})
