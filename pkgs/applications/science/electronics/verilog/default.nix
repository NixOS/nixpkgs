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
  iverilog-test = fetchFromGitHub {
    owner  = "steveicarus";
    repo   = "ivtest";
    rev    = "253609b89576355b3bef2f91e90db62223ecf2be";
    sha256 = "18i7jlr2csp7mplcrwjhllwvb6w3v7x7mnx7vdw48nd3g5scrydx";
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

  # tests try to access /proc/ which does not exist on darwin
  # Cannot locate IVL modules : couldn't get command path from OS.
  doCheck = !stdenv.isDarwin;

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
