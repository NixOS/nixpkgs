{ stdenv, fetchFromGitHub, autoconf, gperf, flex, bison, readline, ncurses
, bzip2, zlib
# Test inputs
, perl
}:

let
  iverilog-test = fetchFromGitHub {
    owner  = "steveicarus";
    repo   = "ivtest";
    rev    = "d4c80beb845cad92136c05074b3910b822a9315f";
    sha256 = "13cpnkki3xmhsh2v4bp2s35mhwknapcikdh85g4q6925ka940r45";
  };
in
stdenv.mkDerivation rec {
  pname   = "iverilog";
  version = "unstable-2020-10-24";

  src = fetchFromGitHub {
    owner  = "steveicarus";
    repo   = pname;
    rev    = "d6e01d0c557253414109a4dde46b2966a5a3fb08";
    sha256 = "1bl75mbycj9zpjbpay8z12384yk9ih5q9agsrjh9pva0vv3h4y4y";
  };

  nativeBuildInputs = [ autoconf gperf flex bison ];
  buildInputs = [ readline ncurses bzip2 zlib ];

  preConfigure = "bash $PWD/autoconf.sh";

  enableParallelBuilding = true;
  doCheck = true;

  # most tests pass, but some that rely on exact text of floating-point numbers
  # fail on aarch64.
  doInstallCheck = !stdenv.isAarch64;
  installCheckInputs = [ perl ];
  installCheckPhase = ''
    # copy tests to allow writing results
    export TESTDIR=$(mktemp -d)
    cp -r ${iverilog-test}/* $TESTDIR

    pushd $TESTDIR

    # Run & check tests
    PATH=$out/bin:$PATH perl vvp_reg.pl
    # Check the tests, will error if unexpected tests fail. Some failures MIGHT be normal.
    diff regression_report-devel.txt regression_report.txt
    PATH=$out/bin:$PATH perl vpi_reg.pl

    popd
  '';

  meta = with stdenv.lib; {
    description = "Icarus Verilog compiler";
    homepage    = "http://iverilog.icarus.com/";
    license     = with licenses; [ gpl2Plus lgpl21Plus ];
    maintainers = with maintainers; [ winden thoughtpolice ];
    platforms   = platforms.all;
  };
}
