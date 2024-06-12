{ lib, stdenv, fetchurl, blas, lapack } :

stdenv.mkDerivation rec {
  pname = "ergoscf";
  version = "3.8.2";

  src = fetchurl {
    url = "http://www.ergoscf.org/source/tarfiles/ergo-${version}.tar.gz";
    sha256 = "sha256-U0NVREEZ8HI0Q0ZcbwvZsYA76PWMh7bqgDG1uaUc01c=";
  };

  buildInputs = [ blas lapack ];

  patches = [ ./math-constants.patch ];

  postPatch = ''
    patchShebangs ./test
  '';

  configureFlags = [
    "--enable-linalgebra-templates"
    "--enable-performance"
  ] ++ lib.optional stdenv.isx86_64 "--enable-sse-intrinsics";

  LDFLAGS = "-lblas -llapack";

  enableParallelBuilding = true;

  OMP_NUM_THREADS = 2; # required for check phase

  # With "fortify3", there are test failures, such as:
  # Testing cnof CAMB3LYP/6-31G using FMM
  # *** buffer overflow detected ***: terminated
  # ./test_fmm_camb3lyp.sh: line 81: 1061289 Aborted                 (core dumped) ./ergo <<EOINPUT > /dev/null
  hardeningDisable = [ "fortify3" ];

  doCheck = true;

  meta = with lib; {
    description = "Quantum chemistry program for large-scale self-consistent field calculations";
    mainProgram = "ergo";
    homepage = "http://www.ergoscf.org";
    license = licenses.gpl3Plus;
    maintainers = [ maintainers.markuskowa ];
    platforms = platforms.linux;
  };
}
