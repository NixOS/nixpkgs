{
  lib,
  stdenv,
  fetchFromGitHub,
  autoreconfHook,
  gfortran,
  guile,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libctl";
  version = "4.5.1";

  src = fetchFromGitHub {
    owner = "NanoComp";
    repo = "libctl";
    rev = "v${finalAttrs.version}";
    sha256 = "uOydBWYPXSBUi+4MM6FNx6B5l2to7Ny9Uc1MMTV9bGA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    gfortran
    guile
    pkg-config
  ];

  configureFlags = [ "--enable-shared" ];

  meta = {
    description = "Guile-based library for supporting flexible control files in scientific simulations";
    mainProgram = "gen-ctl-io";
    homepage = "https://github.com/NanoComp/libctl";
    license = lib.licenses.gpl2Only;
    maintainers = [ ];
  };
})
