{ lib, stdenv
, fetchFromGitHub
, autoconf
, bison
, bzip2
, flex
, gperf
, ncurses
, perl
, readline
, zlib
}:

let
  # iverilog-test has been merged to the main iverilog main source tree
  # in January 2022, so it won't be longer necessary.
  # For now let's fetch it from the separate repo, since 11.0 was released in 2020.
  iverilog-test = fetchFromGitHub {
    owner  = "steveicarus";
    repo   = "ivtest";
    rev    = "a19e629a1879801ffcc6f2e6256ca435c20570f3";
    sha256 = "sha256-3EkmrAXU0/mRxrxp5Hy7C3yWTVK16L+tPqqeEryY/r8=";
  };
in
stdenv.mkDerivation rec {
  pname   = "iverilog";
  version = "11.0";

  src = fetchFromGitHub {
    owner  = "steveicarus";
    repo   = pname;
    rev    = "v${lib.replaceStrings ["."] ["_"] version}";
    sha256 = "0nzcyi6l2zv9wxzsv9i963p3igyjds0n55x0ph561mc3pfbc7aqp";
  };

  nativeBuildInputs = [ autoconf bison flex gperf ];

  buildInputs = [ bzip2 ncurses readline zlib ];

  preConfigure = "sh autoconf.sh";

  enableParallelBuilding = true;

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

  meta = with lib; {
    description = "Icarus Verilog compiler";
    homepage    = "http://iverilog.icarus.com/";  # https does not work
    license     = with licenses; [ gpl2Plus lgpl21Plus ];
    maintainers = with maintainers; [ thoughtpolice ];
    platforms   = platforms.all;
  };
}
