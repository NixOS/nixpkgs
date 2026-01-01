{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
<<<<<<< HEAD
  fuse3,
=======
  fuse,
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  curl,
  expat,
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
  pname = "s3backer";
  version = "2.1.6";

  src = fetchFromGitHub {
    owner = "archiecobbs";
    repo = "s3backer";
    tag = finalAttrs.version;
    hash = "sha256-bSqkgNZFevtxyaJwoVRcWWO6ZA/Ekbp2gwSJNBmjHwI=";
  };

=======
stdenv.mkDerivation rec {
  pname = "s3backer";
  version = "2.1.4";

  src = fetchFromGitHub {
    sha256 = "sha256-QOTQsU2R68217eO2+2yZhBWtjAdkHuVRbCGv1JD0YLQ=";
    rev = version;
    repo = "s3backer";
    owner = "archiecobbs";
  };

  patches = [
    # from upstream, after latest release
    # https://github.com/archiecobbs/s3backer/commit/303a669356fa7cd6bc95ac7076ce51b1cab3970a
    ./fix-darwin-builds.patch
  ];

>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];
  buildInputs = [
<<<<<<< HEAD
    fuse3
=======
    fuse
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    curl
    expat
  ];

  # AC_CHECK_DECLS doesn't work with clang
  postPatch = lib.optionalString stdenv.cc.isClang ''
<<<<<<< HEAD
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
=======
    substituteInPlace configure.ac --replace \
      'AC_CHECK_DECLS(fdatasync)' ""
  '';

  meta = with lib; {
    homepage = "https://github.com/archiecobbs/s3backer";
    description = "FUSE-based single file backing store via Amazon S3";
    license = licenses.gpl2Plus;
    platforms = platforms.unix;
    mainProgram = "s3backer";
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
