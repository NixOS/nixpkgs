{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gopher";
  version = "3.0.19";

  src = fetchFromGitHub {
    owner = "jgoerzen";
    repo = "gopher";
    tag = "release/${finalAttrs.version}";
    hash = "sha256-8J63TnC3Yq7+64PPLrlPEueMa9D/eWkPsb08t1+rPAA=";
  };

  buildInputs = [ ncurses ];

  # C23 (GCC 15 default) rejects K&R empty-parens declarations as no-arg functions
  env.NIX_CFLAGS_COMPILE = "-std=gnu17";

  preConfigure = "export LIBS=-lncurses";

  meta = {
    homepage = "http://gopher.quux.org:70/devel/gopher";
    description = "Ncurses gopher client";
    platforms = lib.platforms.linux; # clang doesn't like local regex.h
    license = lib.licenses.gpl2;
    maintainers = with lib.maintainers; [ sternenseemann ];
  };
})
