{ stdenv
, fetchFromGitHub
, fetchgit
, lib
, autoconf
, automake
, bison
, blas
, flex
, fftw
, gfortran
, lapack
, libtool_2
, mpi
, suitesparse
, trilinos
, withMPI ? false
  # for doc
, texlive
, pandoc
, enableDocs ? true
  # for tests
, bash
, bc
, openssh # required by MPI
, perl
, perlPackages
, python3
, enableTests ? true
}:

assert withMPI -> trilinos.withMPI;

let
  version = "7.6.0";

  # useing fetchurl or fetchFromGitHub doesn't include the manuals
  # due to .gitattributes files
  xyce_src = fetchgit {
    url = "https://github.com/Xyce/Xyce.git";
    rev = "Release-${version}";
    sha256 = "sha256-HYIzmODMWXBuVRZhcC7LntTysuyXN5A9lb2DeCQQtVw=";
  };

  regression_src = fetchFromGitHub {
    owner = "Xyce";
    repo = "Xyce_Regression";
    rev = "Release-${version}";
    sha256 = "sha256-uEoiKpYyHmdK7LZ1UNm2d3Jk8+sCwBwB0TCoHilIh74=";
  };
in

stdenv.mkDerivation rec {
  pname = "xyce";
  inherit version;

  srcs = [ xyce_src regression_src ];

  sourceRoot = xyce_src.name;

  preConfigure = "./bootstrap";

  configureFlags = [
    "CXXFLAGS=-O3"
    "--enable-xyce-shareable"
    "--enable-shared"
    "--enable-stokhos"
    "--enable-amesos2"
  ] ++ lib.optionals withMPI [
    "--enable-mpi"
    "CXX=mpicxx"
    "CC=mpicc"
    "F77=mpif77"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [
    autoconf
    automake
    gfortran
    libtool_2
  ] ++ lib.optionals enableDocs [
    (texlive.combine {
      inherit (texlive)
        scheme-medium
        koma-script
        optional
        framed
        enumitem
        multirow
        preprint;
    })
  ];

  buildInputs = [
    bison
    blas
    flex
    fftw
    lapack
    suitesparse
    trilinos
  ] ++ lib.optionals withMPI [ mpi ];

  doCheck = enableTests;

  postPatch = ''
    pushd ../${regression_src.name}
    find Netlists -type f -regex ".*\.sh\|.*\.pl" -exec chmod ugo+x {} \;
    # some tests generate new files, some overwrite netlists
    find . -type d -exec chmod u+w {} \;
    find . -type f -name "*.cir" -exec chmod u+w {} \;
    patchShebangs Netlists/ TestScripts/
    # patch script generating functions
    sed -i -E 's|/usr/bin/env perl|${lib.escapeRegex perl.outPath}/bin/perl|'  \
      TestScripts/XyceRegression/Testing/Netlists/RunOptions/runOptions.cir.sh
    sed -i -E 's|/bin/sh|${lib.escapeRegex bash.outPath}/bin/sh|' \
      TestScripts/XyceRegression/Testing/Netlists/RunOptions/runOptions.cir.sh
    popd
  '';

  nativeCheckInputs = [
    bc
    perl
    (python3.withPackages (ps: with ps; [ numpy scipy ]))
  ] ++ lib.optionals withMPI [ mpi openssh ];

  checkPhase = ''
    XYCE_BINARY="$(pwd)/src/Xyce"
    EXECSTRING="${lib.optionalString withMPI "mpirun -np 2 "}$XYCE_BINARY"
    TEST_ROOT="$(pwd)/../${regression_src.name}"

    # Honor the TMP variable
    sed -i -E 's|/tmp|\$TMP|' $TEST_ROOT/TestScripts/suggestXyceTagList.sh

    EXLUDE_TESTS_FILE=$TMP/exclude_tests.$$
    # Gold standard has additional ":R" suffix in result column label
    echo "Output/HB/hb-step-tecplot.cir" >> $EXLUDE_TESTS_FILE
    # This test makes Xyce access /sys/class/net when run with MPI
    ${lib.optionalString withMPI "echo \"CommandLine/command_line.cir\" >> $EXLUDE_TESTS_FILE"}

    $TEST_ROOT/TestScripts/run_xyce_regression \
      --output="$(pwd)/Xyce_Test" \
      --xyce_test="''${TEST_ROOT}" \
      --taglist="$($TEST_ROOT/TestScripts/suggestXyceTagList.sh "$XYCE_BINARY" | sed -E -e 's/TAGLIST=([^ ]+).*/\1/' -e '2,$d')" \
      --resultfile="$(pwd)/test_results" \
      --excludelist="$EXLUDE_TESTS_FILE" \
      "''${EXECSTRING}"
  '';

  outputs = [ "out" "doc" ];

  postInstall = lib.optionalString enableDocs ''
    local docFiles=("doc/Users_Guide/Xyce_UG"
      "doc/Reference_Guide/Xyce_RG"
      "doc/Release_Notes/Release_Notes_${lib.versions.majorMinor version}/Release_Notes_${lib.versions.majorMinor version}")

    # Release notes refer to an image not in the repo.
    sed -i -E 's/\\includegraphics\[height=(0.5in)\]\{snllineblubrd\}/\\mbox\{\\rule\{0mm\}\{\1\}\}/' ''${docFiles[2]}.tex

    install -d $doc/share/doc/${pname}-${version}/
    for d in ''${docFiles[@]}; do
      # Use a public document class
      sed -i -E 's/\\documentclass\[11pt,report\]\{SANDreport\}/\\documentclass\[11pt,letterpaper\]\{scrreprt\}/' $d.tex
      sed -i -E 's/\\usepackage\[sand\]\{optional\}/\\usepackage\[report\]\{optional\}/' $d.tex
      pushd $(dirname $d)
      make
      install -t $doc/share/doc/${pname}-${version}/ $(basename $d.pdf)
      popd
    done
  '';

  meta = with lib; {
    broken = (stdenv.isLinux && stdenv.isAarch64) || stdenv.isDarwin;
    description = "High-performance analog circuit simulator";
    longDescription = ''
      Xyce is a SPICE-compatible, high-performance analog circuit simulator,
      capable of solving extremely large circuit problems by supporting
      large-scale parallel computing platforms.
    '';
    homepage = "https://xyce.sandia.gov";
    license = licenses.gpl3;
    maintainers = with maintainers; [ fbeffa ];
    platforms = platforms.all;
  };
}
