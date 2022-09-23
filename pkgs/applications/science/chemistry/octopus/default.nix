{ lib, stdenv, fetchFromGitLab, gfortran, perl, procps
, libyaml, libxc, fftw, blas, lapack, gsl, netcdf, arpack, autoreconfHook
, python3
, enableFma ? stdenv.hostPlatform.fmaSupport
, enableFma4 ? stdenv.hostPlatform.fma4Support
, enableAvx ? stdenv.hostPlatform.avx2Support
, enableAvx512 ? stdenv.hostPlatform.avx512Support
}:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation rec {
  pname = "octopus";
  version = "11.4";

  src = fetchFromGitLab {
    owner = "octopus-code";
    repo = "octopus";
    rev = version;
    sha256 = "1z423sjpc4ajjy3s7623z3rfwmp2hgis7iiiy8gb5apw73k33dyv";
  };

  nativeBuildInputs = [
    perl
    procps
    autoreconfHook
    gfortran
  ];

  buildInputs = [
    libyaml
    libxc
    blas
    lapack
    gsl
    fftw
    netcdf
    arpack
    (python3.withPackages (ps: [ ps.pyyaml ]))
  ];

  configureFlags = with lib; [
    "--with-yaml-prefix=${libyaml}"
    "--with-blas=-lblas"
    "--with-lapack=-llapack"
    "--with-fftw-prefix=${fftw.dev}"
    "--with-gsl-prefix=${gsl}"
    "--with-libxc-prefix=${libxc}"
    "--enable-openmp"
  ] ++ optional enableFma "--enable-fma3"
    ++ optional enableFma4 "--enable-fma4"
    ++ optional enableAvx "--enable-avx"
    ++ optional enableAvx512 "--enable-avx512";

  doCheck = false;
  checkTarget = "check-short";

  postPatch = ''
    patchShebangs ./
  '';

  postConfigure = ''
    patchShebangs testsuite/oct-run_testsuite.sh
  '';

  enableParallelBuilding = true;

  meta = with lib; {
    description = "Real-space time dependent density-functional theory code";
    homepage = "https://octopus-code.org";
    maintainers = with maintainers; [ markuskowa ];
    license = with licenses; [ gpl2Only asl20 lgpl3Plus bsd3 ];
    platforms = [ "x86_64-linux" ];
  };
}
