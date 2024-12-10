{
  lib,
  stdenv,
  fetchpatch,
  fetchFromGitHub,
  autoreconfHook,
  pkg-config,
  flint,
  gmp,
  python3,
  singular,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "pynac";
  version = "0.7.29";

  src = fetchFromGitHub {
    owner = "pynac";
    repo = "pynac";
    rev = "pynac-${finalAttrs.version}";
    hash = "sha256-ocR7emXtKs+Xe2f6dh4xEDAacgiolY8mtlLnWnNBS8A=";
  };

  patches = [
    # the patch below is included in sage 9.4 and should be included
    # in a future pynac release. see https://trac.sagemath.org/ticket/28357
    (fetchpatch {
      name = "realpartloop.patch";
      url = "https://git.sagemath.org/sage.git/plain/build/pkgs/pynac/patches/realpartloop.patch?h=9.4.beta5";
      hash = "sha256-1nj0xtlFN5fZKEiRLD+tiW/ZtxMQre1ziEGA0OVUGE4=";
    })
  ];

  # Python 3.11 moved this header file, but is now is imported by default
  postPatch = ''
    substituteInPlace ginac/numeric.cpp \
        --replace-fail "#include <longintrepr.h>" ""
  '';

  buildInputs = [
    flint
    gmp
    singular
    python3
    ncurses
  ];

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
  ];

  meta = with lib; {
    description = "Python is Not a CAS -- modified version of Ginac";
    longDescription = ''
      Pynac -- "Python is Not a CAS" is a modified version of Ginac that
      replaces the depency of GiNaC on CLN by a dependency instead of Python.
      It is a lite version of GiNaC as well, not implementing all the features
      of the full GiNaC, and it is *only* meant to be used as a Python library.
    '';
    homepage = "http://pynac.org";
    license = licenses.gpl2Plus;
    maintainers = teams.sage.members;
    platforms = platforms.unix;
  };
})
