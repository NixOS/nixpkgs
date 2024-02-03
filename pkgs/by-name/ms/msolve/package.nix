{ lib
, stdenv
, fetchFromGitHub
, autoreconfHook
, flint
, gmp
, mpfr
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "msolve";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "algebraic-solving";
    repo = "msolve";
    rev = "v${finalAttrs.version}";
    hash = "sha256-hdrNqZjTGhGFrshswJGPVgBjOUfHh93aQUfBKLlk5Es=";
  };

  postPatch = ''
    patchShebangs .
  '';

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    flint
    gmp
    mpfr
  ];

  doCheck = true;

  meta = with lib; {
    description = "Library for polynomial system solving through algebraic methods";
    homepage = "https://msolve.lip6.fr";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
  };
})
