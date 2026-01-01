{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  guile,
  pkg-config,
  texinfo,
}:

stdenv.mkDerivation {
  pname = "guile-commonmark";
  version = "unstable-2020-04-30";

  src = fetchFromGitHub {
    owner = "OrangeShark";
    repo = "guile-commonmark";
    rev = "538ffea25ca69d9f3ee17033534ba03cc27ba468";
    hash = "sha256-9cA7iQ/GGEx+HwsdAxKC3IssqkT/Yg8ZxaiIprS5VuI=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    texinfo # for makeinfo
  ];
  buildInputs = [
    guile
  ];

  # https://github.com/OrangeShark/guile-commonmark/issues/20
  doCheck = false;

  makeFlags = [
    "GUILE_AUTO_COMPILE=0"
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/OrangeShark/guile-commonmark";
    description = "Implementation of CommonMark for Guile";
    license = lib.licenses.lgpl3Plus;
=======
  meta = with lib; {
    homepage = "https://github.com/OrangeShark/guile-commonmark";
    description = "Implementation of CommonMark for Guile";
    license = licenses.lgpl3Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    platforms = guile.meta.platforms;
  };
}
