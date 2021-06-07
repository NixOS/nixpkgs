{ lib, stdenv, fetchFromGitHub, autoconf, automake, libtool, ncurses }:

stdenv.mkDerivation rec {
  pname = "imgcat";
  version = "2.3.1";

  nativeBuildInputs = [ autoconf automake libtool ];
  buildInputs = [ ncurses ];

  preConfigure = ''
    ${autoconf}/bin/autoconf
    sed -i -e "s|-ltermcap|-L ${ncurses}/lib -lncurses|" Makefile
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  src = fetchFromGitHub {
    owner = "eddieantonio";
    repo = pname;
    rev = "v${version}";
    sha256 = "0frz40rjwi73nx2dlqvmnn56zwr29bmnngfb11hhwr7v58yfajdi";
  };

  NIX_CFLAGS_COMPILE = "-Wno-error";

  meta = with lib; {
    description = "It's like cat, but for images";
    homepage = "https://github.com/eddieantonio/imgcat";
    license = licenses.isc;
    maintainers = with maintainers; [ jwiegley ];
    platforms = platforms.unix;
  };
}

