{
  lib,
  stdenv,
  fetchFromGitHub,
  gfortran,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mela";
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "vbertone";
    repo = "MELA";
    rev = finalAttrs.version;
    sha256 = "01sgd4mwx4n58x95brphp4dskqkkx8434bvsr38r5drg9na5nc9y";
  };

  nativeBuildInputs = [ gfortran ];

  enableParallelBuilding = true;

  meta = {
    description = "Mellin Evolution LibrAry";
    mainProgram = "mela-config";
    license = lib.licenses.gpl3;
    homepage = "https://github.com/vbertone/MELA";
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ veprbl ];
  };
})
