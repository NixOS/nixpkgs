{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gmp,
  zlib,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "4.3.1";
  pname = "form";

  src = fetchFromGitHub {
    owner = "form-dev";
    repo = "form";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZWpfPeTekHEALqXVF/nLkcNsrkt17AKm2B/uydUBfvo=";
  };

  nativeBuildInputs = [
    autoreconfHook
  ];

  buildInputs = [
    gmp
    zlib
  ];

  meta = with lib; {
    description = "Symbolic manipulation of very big expressions";
    homepage = "https://www.nikhef.nl/~form/";
    license = licenses.gpl3;
    maintainers = [ maintainers.veprbl ];
    platforms = platforms.unix;
  };
})
