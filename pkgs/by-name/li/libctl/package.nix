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
  version = "4.6.0";

  src = fetchFromGitHub {
    owner = "NanoComp";
    repo = "libctl";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-p6OEPbqdkLB7n6KcC6DCRNnz7eKOq53z9T7xwnCATNM=";
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
