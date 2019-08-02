{ stdenv, fetchFromGitHub, autoconf, gperf, flex, bison, readline, ncurses
, bzip2, zlib
}:

stdenv.mkDerivation rec {
  pname = "iverilog";
  version = "unstable-2019-08-01";

  src = fetchFromGitHub {
    owner  = "steveicarus";
    repo = pname;
    rev    = "c383d2048c0bd15f5db083f14736400546fb6215";
    sha256 = "1zs0gyhws0qa315magz3w5m45v97knczdgbf2zn4d7bdb7cv417c";
  };

  enableParallelBuilding = true;

  prePatch = ''
    substituteInPlace configure.in \
      --replace "AC_CHECK_LIB(termcap, tputs)" "AC_CHECK_LIB(termcap, tputs)"
  '';

  preConfigure = ''
    chmod +x $PWD/autoconf.sh
    $PWD/autoconf.sh
  '';

  nativeBuildInputs = [ autoconf gperf flex bison ];

  buildInputs = [ readline ncurses bzip2 zlib ];

  meta = with stdenv.lib; {
    description = "Icarus Verilog compiler";
    repositories.git = https://github.com/steveicarus/iverilog.git;
    homepage = "http://iverilog.icarus.com/";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ winden ];
    platforms = platforms.linux;
  };
}
