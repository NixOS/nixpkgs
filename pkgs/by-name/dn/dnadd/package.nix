{
  lib,
  stdenv,
  fetchFromGitHub,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "dnadd";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "JoeLancaster";
    repo = "dnadd";
    rev = "v${finalAttrs.version}";
    hash = "sha256-mbQhBl/MfUNuPnKQyAnV4wyZl/sskq6/pkS+5NF/6+8=";
  };

  strictDeps = true;
  makeFlags = [ "PREFIX=$(out)" ];

  meta = {
    homepage = "https://github.com/joelancaster/dnadd";
    description = "Adds packages declaratively on the command line";
    mainProgram = "dnadd";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ joelancaster ];
    platforms = lib.platforms.linux;
  };
})
