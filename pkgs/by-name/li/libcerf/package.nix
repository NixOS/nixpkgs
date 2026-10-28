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
  version = "3.8";

  src = fetchFromGitLab {
    domain = "jugit.fz-juelich.de";
    group = "mlz";
    owner = "lib";
    repo = "cerf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-G0a79i9EqUSoVq2ngdNqqCodTh3AG4apR3t8lqRP4lk=";
  };

  nativeBuildInputs = [
    cmake
    perl
  ];

  doCheck = true;

  passthru = {
    tests = {
      inherit gnuplot;
    };
    updateScript = nix-update-script { };
  };

  meta = {
    changelog = "https://jugit.fz-juelich.de/mlz/lib/cerf/-/blob/${finalAttrs.src.tag}/CHANGELOG";
    description = "Complex error (erf), Dawson, Faddeeva, and Voigt function library";
    homepage = "https://jugit.fz-juelich.de/mlz/lib/cerf";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ hythera ];
    platforms = lib.platforms.all;
  };
})
