{ stdenv, fetchFromGitHub, autoconf, gperf, flex, bison, readline, ncurses
, bzip2, zlib
# Test inputs
, perl
}:

let
  iverilog-test = fetchFromGitHub {
    owner = "steveicarus";
    repo = "ivtest";
    rev = "6882cb8ec08926c4e356c6092f0c5f8c23328d5c";
    sha256 = "04sj5nqzwls1y760kgnd9c2whkcrr8kvj9lisd5rvk0w580kjb2x";
  };
in
stdenv.mkDerivation rec {
  pname = "iverilog";
  version = "unstable-2020-08-24";

  src = fetchFromGitHub {
    owner = "steveicarus";
    repo = pname;
    rev = "d8556e4c86e1465b68bdc8d5ba2056ba95a42dfd";
    sha256 = "sha256-sT9j/0Q2FD5MOGpH/quMGvAuM7t7QavRHKD9lX7Elfs=";
  };

  enableParallelBuilding = true;

  preConfigure = ''
    chmod +x $PWD/autoconf.sh
    $PWD/autoconf.sh
  '';

  nativeBuildInputs = [ autoconf gperf flex bison ];

  buildInputs = [ readline ncurses bzip2 zlib ];

  # tests from .travis.yml
  doCheck = true; # runs ``make check``
  # most tests pass, but some that rely on exact text of floating-point numbers fail on aarch64.
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
    homepage = "http://iverilog.icarus.com/";
    license = with licenses; [ gpl2Plus lgpl21Plus] ;
    maintainers = with maintainers; [ winden ];
    platforms = platforms.all;
  };
}
