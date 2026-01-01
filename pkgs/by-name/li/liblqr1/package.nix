{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  glib,
}:

<<<<<<< HEAD
stdenv.mkDerivation (finalAttrs: {
=======
stdenv.mkDerivation rec {
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  pname = "liblqr-1";
  version = "0.4.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "carlobaldassi";
    repo = "liblqr";
<<<<<<< HEAD
    rev = "v${finalAttrs.version}";
    hash = "sha256-rgVX+hEGRfWY1FvwDBLy5nLPOyh2JE4+lB0KOmahuYI=";
  };

  # Fix build with gcc15
  env = lib.optionalAttrs stdenv.cc.isGNU {
    NIX_CFLAGS_COMPILE = "-std=gnu17";
=======
    rev = "v${version}";
    sha256 = "10mrl5k3l2hxjhz4w93n50xwywp6y890rw2vsjcgai8627x5f1df";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  nativeBuildInputs = [ pkg-config ];
  propagatedBuildInputs = [ glib ];

<<<<<<< HEAD
  meta = {
    homepage = "http://liblqr.wikidot.com";
    description = "Seam-carving C/C++ library called Liquid Rescaling";
    platforms = lib.platforms.all;
    license = with lib.licenses; [
=======
  meta = with lib; {
    homepage = "http://liblqr.wikidot.com";
    description = "Seam-carving C/C++ library called Liquid Rescaling";
    platforms = platforms.all;
    license = with licenses; [
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
      gpl3
      lgpl3
    ];
  };
<<<<<<< HEAD
})
=======
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
