{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  guile,
  libevent,
  pkg-config,
  texinfo,
}:

stdenv.mkDerivation rec {
  pname = "guile-fibers";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "wingo";
    repo = "fibers";
    rev = "v${version}";
    hash = "sha256-jJKA5JEHsmqQ/IKb1aNmOtoVaGKNjcgTKyo5VCiJbXM=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    autoreconfHook
    guile
    pkg-config
    texinfo # for makeinfo
  ];

  buildInputs = [
    guile
    libevent
  ];

  makeFlags = [
    "GUILE_AUTO_COMPILE=0"
  ];

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/wingo/fibers";
    description = "Concurrent ML-like concurrency for Guile";
    license = lib.licenses.lgpl3Plus;
=======
  meta = with lib; {
    homepage = "https://github.com/wingo/fibers";
    description = "Concurrent ML-like concurrency for Guile";
    license = licenses.lgpl3Plus;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    maintainers = [ ];
    platforms = guile.meta.platforms;
  };
}
