{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  fuse3,
  curl,
  expat,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "s3backer";
  version = "2.1.6";

  src = fetchFromGitHub {
    hash = "sha256-bSqkgNZFevtxyaJwoVRcWWO6ZA/Ekbp2gwSJNBmjHwI=";
    tag = finalAttrs.version;
    repo = "s3backer";
    owner = "archiecobbs";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
    fuse3
    curl
    expat
  ];

  # AC_CHECK_DECLS doesn't work with clang
  postPatch = lib.optionalString stdenv.cc.isClang ''
    substituteInPlace configure.ac --replace-fail \
      'AC_CHECK_DECLS(fdatasync)' ""
  '';

  meta = {
    homepage = "https://github.com/archiecobbs/s3backer";
    description = "FUSE-based single file backing store via Amazon S3";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "s3backer";
  };
})
