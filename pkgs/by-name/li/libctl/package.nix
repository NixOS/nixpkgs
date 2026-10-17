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
  version = "4.7.1";

  src = fetchFromGitHub {
    owner = "NanoComp";
    repo = "libctl";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-2Z/zFFhH2l+FDDhBCqPnvRYHUsNlfg7el+900hl6E8A=";
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
