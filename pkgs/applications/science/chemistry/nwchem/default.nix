{ lib
, stdenv
, pkgs
, fetchFromGitHub
, fetchurl
, mpiCheckPhaseHook
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
  versionGA = "5.8.2"; # Fixed by nwchem

  gaSrc = fetchFromGitHub {
    owner = "GlobalArrays";
    repo = "ga";
    rev = "v${versionGA}";
    hash = "sha256-2ffQIg9topqKX7ygnWaa/UunL9d0Lj9qr9xucsjLuoY=";
  };

  dftd3Src = fetchurl {
    url = "https://www.chemiebn.uni-bonn.de/pctc/mulliken-center/software/dft-d3/dftd3.tgz";
    hash = "sha256-2Xz5dY9hqoH9hUJUSPv0pujOB8EukjZzmDGjrzKID1k=";
  };

  versionLibxc = "6.1.0";
  libxcSrc = fetchurl {
    url = "https://gitlab.com/libxc/libxc/-/archive/${versionLibxc}/libxc-${versionLibxc}.tar.gz";
    hash = "sha256-9ZN0X6R+v7ndxGeqr9wvoSdfDXJQxpLOl2E4mpDdjq8=";
  };

  plumedSrc = fetchFromGitHub {
    owner = "edoapra";
    repo = "plumed2";
    rev = "e7c908da50bde1c6399c9f0e445d6ea3330ddd9b";
    hash = "sha256-CNlb6MTEkD977hj3xonYqZH1/WlQ1EdVD7cvL//heRM=";
  };

in
stdenv.mkDerivation rec {
  pname = "nwchem";
  version = "7.2.0";

  src = fetchFromGitHub {
    owner = "nwchemgit";
    repo = "nwchem";
    rev = "v${version}-release";
    hash = "sha256-/biwHOSMGpdnYRGrGlDounKKLVaG2XkBgCmpE0IKR/Y=";
  };

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
    # These run 'configure' in source tree and
    # require a writable directory
    cp -r ${gaSrc}/ source/src/tools/ga-${versionGA}
    chmod -R u+w source/src/tools/ga-${versionGA}

    cp -r ${plumedSrc} source/src/libext/plumed/plumed2
    chmod -R u+w source/src/libext/plumed/plumed2

    # Provide tarball in expected location
    ln -s ${dftd3Src} source/src/nwpw/nwpwlib/nwpwxc/dftd3.tgz
    ln -s ${libxcSrc} source/src/libext/libxc/libxc-${versionLibxc}.tar.gz
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

    export CCSDTQ="y"

    export NWCHEM_TOP="$(pwd)"

    runHook postConfigure
  '';

  enableParallelBuilding = true;

  preBuild = ''
    ln -s ${gaSrc} src/tools/ga-${versionGA}.tar.gz
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
  nativeCheckInputs = [ mpiCheckPhaseHook ];
  installCheckPhase = ''
    runHook preInstallCheck

    # run a simple water test
    mpirun -np 2 $out/bin/nwchem $out/share/nwchem/QA/tests/h2o/h2o.nw > h2o.out
    grep "Total SCF energy" h2o.out  | grep 76.010538

    runHook postInstallCheck
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
