{ lib
, stdenv
, pkgs
, fetchFromGitHub
, fetchpatch
, which
, openssh
, gcc
, gfortran
, perl
, mpi
, blas
, lapack
, python3
, tcsh
, bash
, automake
, autoconf
, libtool
, makeWrapper
}:

assert blas.isILP64 == lapack.isILP64;

let
  versionGA = "5.7.2"; # Fixed by nwchem

  ga_src = fetchFromGitHub {
    owner = "GlobalArrays";
    repo = "ga";
    rev = "v${versionGA}";
    sha256 = "0c1y9a5jpdw9nafzfmvjcln1xc2gklskaly0r1alm18ng9zng33i";
  };

in
stdenv.mkDerivation rec {
  pname = "nwchem";
  version = "7.0.2";

  src = fetchFromGitHub {
    owner = "nwchemgit";
    repo = "nwchem";
    rev = "v${version}-release";
    sha256 = "1ckhcjaw1hzdsmm1x2fva27c4rs3r0h82qivg72v53idz880hbp3";
  };

  patches = [
    # Fix Python 3.10 compatibility
    (fetchpatch {
      name = "python3.10";
      url = "https://github.com/nwchemgit/nwchem/commit/638401361c6f294164a4f820ff867a62ac836fd5.patch";
      sha256 = "sha256-yUZb3wWYZm1dX0HwvffksFwhVdb7ix1p8ooJnqiSgEg=";
    })
  ];

  nativeBuildInputs = [
    perl
    automake
    autoconf
    libtool
    makeWrapper
    gfortran
    which
  ];
  buildInputs = [
    tcsh
    openssh
    blas
    lapack
    python3
  ];
  propagatedBuildInputs = [ mpi ];
  propagatedUserEnvPkgs = [ mpi ];

  postUnpack = ''
    cp -r ${ga_src}/ source/src/tools/ga-${versionGA}
    chmod -R u+w source/src/tools/ga-${versionGA}
  '';

  postPatch = ''
    find -type f -executable -exec sed -i "s:/bin/csh:${tcsh}/bin/tcsh:" \{} \;
    find -type f -name "GNUmakefile" -exec sed -i "s:/usr/bin/gcc:${gcc}/bin/gcc:" \{} \;
    find -type f -name "GNUmakefile" -exec sed -i "s:/bin/rm:rm:" \{} \;
    find -type f -executable -exec sed -i "s:/bin/rm:rm:" \{} \;
    find -type f -name "makelib.h" -exec sed -i "s:/bin/rm:rm:" \{} \;

    # Overwrite script, skipping the download
    echo -e '#!/bin/sh\n cd ga-${versionGA};autoreconf -ivf' > src/tools/get-tools-github

    patchShebangs ./
  '';

  # There is no configure script. Instead the build is controlled via
  # environment variables passed to the Makefile
  configurePhase = ''
    runHook preConfigure

    # config parameters
    export NWCHEM_TARGET="LINUX64"

    export ARMCI_NETWORK="MPI-PR"
    export USE_MPI="y"
    export USE_MPIF="y"

    export NWCHEM_MODULES="all python"

    export USE_PYTHONCONFIG="y"
    export USE_PYTHON64="n"
    export PYTHONLIBTYPE="so"
    export PYTHONHOME="${python3}"
    export PYTHONVERSION=${lib.versions.majorMinor python3.version}

    export BLASOPT="-L${blas}/lib -lblas"
    export LAPACK_LIB="-L${lapack}/lib -llapack"
    export BLAS_SIZE=${if blas.isILP64 then "8" else "4"}

    # extra TCE related options
    export MRCC_METHODS="y"
    export EACCSD="y"
    export IPCCSD="y"

    export NWCHEM_TOP="$(pwd)"

    runHook postConfigure
  '';

  enableParallelBuilding = true;

  preBuild = ''
    ln -s ${ga_src} src/tools/ga-${versionGA}.tar.gz
    cd src
    make nwchem_config
    ${lib.optionalString (!blas.isILP64) "make 64_to_32"}
  '';

  postBuild = ''
    cd $NWCHEM_TOP/src/util
    make version
    make
    cd $NWCHEM_TOP/src
    make link
  '';

  installPhase = ''
    mkdir -p $out/bin $out/share/nwchem

    cp $NWCHEM_TOP/bin/LINUX64/nwchem $out/bin/nwchem
    cp -r $NWCHEM_TOP/src/data $out/share/nwchem/
    cp -r $NWCHEM_TOP/src/basis/libraries $out/share/nwchem/data
    cp -r $NWCHEM_TOP/src/nwpw/libraryps $out/share/nwchem/data
    cp -r $NWCHEM_TOP/QA $out/share/nwchem

    wrapProgram $out/bin/nwchem \
      --set-default NWCHEM_BASIS_LIBRARY $out/share/nwchem/data/libraries/

    cat > $out/share/nwchem/nwchemrc << EOF
    nwchem_basis_library $out/share/nwchem/data/libraries/
    nwchem_nwpw_library $out/share/nwchem//data/libraryps/
    ffield amber
    amber_1 $out/share/nwchem/data/amber_s/
    amber_2 $out/share/nwchem/data/amber_q/
    amber_3 $out/share/nwchem/data/amber_x/
    amber_4 $out/share/nwchem/data/amber_u/
    spce    $out/share/nwchem/data/solvents/spce.rst
    charmm_s $out/share/nwchem/data/charmm_s/
    charmm_x $out/share/nwchem/data/charmm_x/
    EOF
  '';

  doCheck = false;

  doInstallCheck = true;
  installCheckPhase = ''
    export OMP_NUM_THREADS=1

    # Fix to make mpich run in a sandbox
    export HYDRA_IFACE=lo
    export OMPI_MCA_rmaps_base_oversubscribe=1

    # run a simple water test
    mpirun -np 2 $out/bin/nwchem $out/share/nwchem/QA/tests/h2o/h2o.nw > h2o.out
    grep "Total SCF energy" h2o.out  | grep 76.010538
  '';

  passthru = { inherit mpi; };

  meta = with lib; {
    description = "Open Source High-Performance Computational Chemistry";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ sheepforce markuskowa ];
    homepage = "https://nwchemgit.github.io";
    license = licenses.ecl20;
  };
}
