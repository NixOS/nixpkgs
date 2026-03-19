{
  stdenv,
  lib,
  cmake,
  fetchFromGitLab,
  gnuplot,
  nix-update-script,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "libcerf";
  version = "3.3";

  src = fetchFromGitLab {
    domain = "jugit.fz-juelich.de";
    owner = "mlz";
    repo = "libcerf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EPloejabyLzLP+GIPSIsh6dZDk2WodSEU6CPoICRxnM=";
  };

  nativeBuildInputs = [
    cmake
    perl
  ];

  passthru = {
    tests = {
      inherit gnuplot;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Complex error (erf), Dawson, Faddeeva, and Voigt function library";
    homepage = "https://jugit.fz-juelich.de/mlz/libcerf";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = lib.platforms.all;
  };
})
