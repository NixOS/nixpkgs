{
  lib,
  stdenv,
  fetchFromBitbucket,
  pkg-config,
  fuse,
  libzip,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "fuse-zip";
  version = "0.7.2";

  src = fetchFromBitbucket {
    owner = "agalanin";
    repo = "fuse-zip";
    tag = finalAttrs.version;
    hash = "sha256-o1OEOAmo0r/qUyKTgpvJe2XDWgpvash2+oyqdiEq2a8=";
  };

  __structuredAttrs = true;
  enableParallelBuilding = true;
  strictDeps = true;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    fuse
    libzip
  ];

  makeFlags = [
    "prefix=$(out)"
  ];

  buildFlags = [
    "release"
  ];

  # Missing TCL libraries and TCL libraries that are in Nixpkgs that need additional configuration.
  doCheck = false;

  meta = {
    homepage = "https://bitbucket.org/agalanin/fuse-zip";
    changelog = "https://bitbucket.org/agalanin/fuse-zip/src/${finalAttrs.version}/changelog";
    description = "FUSE filesystem for mounting ZIP archives with write support";
    mainProgram = "fuse-zip";
    license = lib.licenses.gpl3Plus;
    maintainers = [ lib.maintainers.RossSmyth ];
    platforms = lib.platforms.linux;
  };
})
