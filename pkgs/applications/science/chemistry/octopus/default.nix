{ stdenv, fetchFromGitLab, symlinkJoin, gfortran, perl, procps
, libyaml, libxc, fftw, openblas, gsl, netcdf, arpack, autoreconfHook
}:

stdenv.mkDerivation rec {
  pname = "octopus";
  version = "9.2";

  src = fetchFromGitLab {
    owner = "octopus-code";
    repo = "octopus";
    rev = version;
    sha256 = "083z51sjv70asr04rv53wb9gf4396nblq1zl22qw7jdr28hji4is";
  };

  nativeBuildInputs = [ perl procps autoreconfHook ];
  buildInputs = [ libyaml gfortran libxc openblas gsl fftw netcdf arpack ];

  configureFlags = [
    "--with-yaml-prefix=${libyaml}"
    "--with-blas=-lopenblas"
    "--with-lapack=-lopenblas"
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
    homepage = https://octopus-code.org;
    maintainers = with maintainers; [ markuskowa ];
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" ];
  };
}
