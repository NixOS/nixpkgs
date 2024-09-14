{
  lib,
  autoreconfHook,
  fetchFromGitHub,
  guile,
  pkg-config,
  stdenv,
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
    guile
    pkg-config
    texinfo # for makeinfo
  ];

  buildInputs = [ guile ];

  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  # https://github.com/OrangeShark/guile-commonmark/issues/20
  doCheck = false;

  strictDeps = true;

  meta = {
    homepage = "https://github.com/OrangeShark/guile-commonmark";
    description = "Implementation of CommonMark for Guile";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ AndersonTorres ];
    inherit (guile.meta) platforms;
  };
}
