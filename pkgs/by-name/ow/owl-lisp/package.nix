{
  lib,
  stdenv,
  fetchFromGitLab,
  which,
  dash,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "owl-lisp";
  version = "0.2.1";

  src = fetchFromGitLab {
    owner = "owl-lisp";
    repo = "owl";
    rev = "v${finalAttrs.version}";
    hash = "sha256-TQOj3DYmzFT4ClZ/sBAOs5XJWRgGTaVQjH+8JotSb1A=";
  };

  nativeBuildInputs = [
    which
    dash
  ];

  # Tests fail with bash, replacing with dash seems to work around it
  # FIXME: Why?
  postPatch = ''
    substituteInPlace Makefile \
      --replace-fail 'sh tests/run' 'dash tests/run'
  '';

  makeFlags = [
    "PREFIX=${placeholder "out"}"
    "CC=${stdenv.cc.targetPrefix}cc"
  ];

  # tests are run as part of the compilation process
  doCheck = false;

  meta = {
    description = "Functional Scheme for world domination";
    homepage = "https://gitlab.com/owl-lisp/owl";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ peterhoeg ];
    platforms = lib.platforms.unix;
  };
})
