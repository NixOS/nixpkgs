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
  version = "0.7.2";

  src = fetchFromGitHub {
    owner = "algebraic-solving";
    repo = "msolve";
    rev = "v${finalAttrs.version}";
    hash = "sha256-p7fD954aMApyBP58cvGrPwHEqhkxWlaiDHUlQT7kX4c=";
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
    mainProgram = "msolve";
    homepage = "https://msolve.lip6.fr";
    license = licenses.gpl2Plus;
    maintainers = with maintainers; [ wegank ];
    platforms = platforms.unix;
  };
})
