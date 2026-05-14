{
  lib,
  stdenv,
  fetchFromSourcehut,
  pkg-config,
  fuse,
  libarchive,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "archivemount";
  version = "1b";

  src = fetchFromSourcehut {
    owner = "~nabijaczleweli";
    repo = "archivemount-ng";
    rev = finalAttrs.version;
    hash = "sha256-QQeVr3kPLVX543PwM2jtMnVQgkEfiQd09hG9VQvqLng=";
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

  # Fix cross-compilation
  postPatch = ''
    substituteInPlace Makefile --replace-fail pkg-config "$PKG_CONFIG"
  '';

  meta = {
    description = "Gateway between FUSE and libarchive: allows mounting of cpio, .tar.gz, .tar.bz2 archives";
    changelog = "https://git.sr.ht/~nabijaczleweli/archivemount-ng/refs/${finalAttrs.version}";
    mainProgram = "archivemount";
    license = [
      lib.licenses.lgpl2Plus
      lib.licenses.bsd0
    ];
    platforms = lib.platforms.unix;
  };
})
