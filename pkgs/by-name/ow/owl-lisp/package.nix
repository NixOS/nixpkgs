{
  lib,
  stdenv,
  fetchFromGitLab,
  which,
  dash,
}:

stdenv.mkDerivation rec {
  pname = "owl-lisp";
  version = "0.2.2";

  src = fetchFromGitLab {
    owner = "owl-lisp";
    repo = "owl";
    rev = "v${version}";
    hash = "sha256-GfvOkYLo8fgAvGuUa59hDy+sWJSwyntwqMO8TAK/lUo=";
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

  meta = with lib; {
    description = "Functional Scheme for world domination";
    homepage = "https://gitlab.com/owl-lisp/owl";
    license = licenses.mit;
    maintainers = with maintainers; [ peterhoeg ];
    platforms = platforms.unix;
  };
}
