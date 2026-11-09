{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  perl,
  zlib,
  bzip2,
  popt,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "librsync";
  version = "2.3.4";

  src = fetchFromGitHub {
    owner = "librsync";
    repo = "librsync";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-fiOby8tOhv0KJ+ZwAWfh/ynqHlYC9kNqKfxNl3IhzR8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    perl
    zlib
    bzip2
    popt
  ];

  outputs = [
    "out"
    "dev"
    "man"
  ]
  # Avoid cycle dependence between out and lib outputs on Darwin, by using bin
  # instead of lib
  ++ (if stdenv.hostPlatform.isDarwin then [ "bin" ] else [ "lib" ]);

  meta = {
    description = "Implementation of the rsync remote-delta algorithm";
    homepage = "https://librsync.sourceforge.net/";
    changelog = "https://github.com/librsync/librsync/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.lgpl2Plus;
    mainProgram = "rdiff";
    platforms = lib.platforms.unix;
  };
})
