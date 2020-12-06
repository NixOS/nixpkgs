{ stdenv, fetchFromGitLab, symlinkJoin, gfortran, perl, procps
, libyaml, libxc, fftw, blas, lapack, gsl, netcdf, arpack, autoreconfHook
}:

assert (!blas.isILP64) && (!lapack.isILP64);

stdenv.mkDerivation rec {
  pname = "octopus";
  version = "10.0";

  src = fetchFromGitLab {
    owner = "octopus-code";
    repo = "octopus";
    rev = version;
    sha256 = "1c6q20y0x9aacwa7vp6gj3yvfzain7hnk6skxmvg3wazp02l91kn";
  };

  nativeBuildInputs = [ perl procps autoreconfHook ];
  buildInputs = [ libyaml gfortran libxc blas lapack gsl fftw netcdf arpack ];

  configureFlags = [
    "--with-yaml-prefix=${libyaml}"
    "--with-blas=-lblas"
    "--with-lapack=-llapack"
    "--with-fftw-prefix=${fftw.dev}"
    "--with-gsl-prefix=${gsl}"
    "--with-libxc-prefix=${libxc}"
  ];

  doCheck = false;
  checkTarget = "check-short";

  postPatch = ''
    patchShebangs ./
  '';

  postConfigure = ''
    patchShebangs testsuite/oct-run_testsuite.sh
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Real-space time dependent density-functional theory code";
    homepage = "https://octopus-code.org";
    maintainers = with maintainers; [ markuskowa ];
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" ];
  };
}
