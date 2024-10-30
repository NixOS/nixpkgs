{
  lib,
  stdenv,
  fetchFromSourcehut,
  fetchpatch,
  pkg-config,
  fuse,
  libarchive,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "archivemount";
  version = "1";

  src = fetchFromSourcehut {
    owner = "~nabijaczleweli";
    repo = "archivemount-ng";
    rev = finalAttrs.version;
    hash = "sha256-xuLtbqC9iS86BKz4jG8of4id+GTlBXoohONrkmIzOpY=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    fuse
    libarchive
  ];

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "VERSION=${finalAttrs.version}"
  ];

  dontConfigure = true;

  # Fix missing standard struct stat on Darwin
  # Already on upstream, but no new release made
  patches = [
    (fetchpatch {
      name = "fix-missing-standard-struct-stat-on-darwin.patch";
      url = "https://git.sr.ht/~nabijaczleweli/archivemount-ng/commit/53dd70f05fdb6ababe7c1ca70f0f62bcf4930b5a.patch";
      hash = "sha256-UqoALAJoNXihop6Mem4mu+W8REOV92Zyv7pPW20Ugz8=";
    })
  ];

  # Fix cross-compilation
  postPatch = ''
    substituteInPlace Makefile --replace-fail pkg-config "$PKG_CONFIG"
  '';

  meta = {
    description = "Gateway between FUSE and libarchive: allows mounting of cpio, .tar.gz, .tar.bz2 archives";
    mainProgram = "archivemount";
    license = [
      lib.licenses.lgpl2Plus
      lib.licenses.bsd0
    ];
    platforms = lib.platforms.unix;
  };
})
