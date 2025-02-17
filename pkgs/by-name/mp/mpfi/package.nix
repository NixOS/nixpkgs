{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  autoreconfHook,
  texinfo,
  mpfr,
}:
stdenv.mkDerivation rec {
  pname = "mpfi";
  version = "1.5.4";

  src = fetchFromGitLab {
    domain = "gitlab.inria.fr";
    owner = "mpfi";
    repo = "mpfi";

    # Apparently there is an upstream off-by-one-commit error in tagging
    # Conditional to allow auto-updaters to try new releases
    # TODO: remove the conditional after an upstream update
    # rev = version;
    rev = if version == "1.5.4" then "feab26bc54529417af983950ddbffb3a4c334d4f" else version;

    sha256 = "sha256-aj/QmJ38ifsW36JFQcbp55aIQRvOpiqLHwEh/aFXsgo=";
  };

  sourceRoot = "${src.name}/mpfi";

  patches = [
    (fetchpatch {
      name = "incorrect-types-corrected.patch";
      url = "https://gitlab.inria.fr/mpfi/mpfi/-/commit/a02e3f9cc10767cc4284a2ef6554f6df85e41982.patch";
      relative = "mpfi";
      hash = "sha256-ogUoZbQMkZMF8chSGdDymH/ewzjKSSc7GAMK2Wp58uo=";
    })
  ];

  nativeBuildInputs = [
    autoreconfHook
    texinfo
  ];
  buildInputs = [ mpfr ];

  meta = {
    description = "Multiple precision interval arithmetic library based on MPFR";
    homepage = "http://perso.ens-lyon.fr/nathalie.revol/software.html";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ lib.maintainers.raskin ];
    platforms = lib.platforms.unix;
  };
}
