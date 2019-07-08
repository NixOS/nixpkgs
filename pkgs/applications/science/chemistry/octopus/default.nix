{ stdenv, fetchurl, symlinkJoin, gfortran, perl, procps
, libyaml, libxc, fftw, openblas, gsl, netcdf, arpack
}:

let
  version = "9.0";
  fftwAll = symlinkJoin { name ="ftw-dev-out"; paths = [ fftw.dev fftw.out ]; };

in stdenv.mkDerivation {
  name = "octopus-${version}";

  src = fetchurl {
    url = "http://www.tddft.org/programs/octopus/down.php?file=${version}/octopus-${version}.tar.gz";
    sha256 = "0p1gjykjnzm4m93mgjsmnxd0n2j381jk5kn3a7gkzxanixp60ilm";
  };

  nativeBuildInputs = [ perl procps fftw.dev ];
  buildInputs = [ libyaml gfortran libxc openblas gsl fftw.out netcdf arpack ];

  configureFlags = [
    "--with-yaml-prefix=${libyaml}"
    "--with-blas=-lopenblas"
    "--with-lapack=-lopenblas"
    "--with-fftw-prefix=${fftwAll}"
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
    homepage = http://octopus-code.org;
    maintainers = with maintainers; [ markuskowa ];
    license = licenses.gpl2;
    platforms = [ "x86_64-linux" ];
  };
}
