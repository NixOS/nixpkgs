{ stdenv, fetchFromGitHub, autoconf, gperf, flex, bison, readline, ncurses
, bzip2, zlib
}:

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

  meta = with stdenv.lib; {
    description = "Icarus Verilog compiler";
    homepage = "http://iverilog.icarus.com/";
    license = with licenses; [ gpl2Plus lgpl21Plus] ;
    maintainers = with maintainers; [ winden ];
    platforms = platforms.all;
  };
}
