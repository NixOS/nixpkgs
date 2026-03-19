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
  version = "3.2";

  src = fetchFromGitLab {
    domain = "jugit.fz-juelich.de";
    owner = "mlz";
    repo = "libcerf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q79E9YsmYFRZI21vi62d8tWA/+AU3YJMaY1CgdTLQGc=";
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
