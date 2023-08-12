{ lib, stdenv, fetchFromGitHub, cimg, ncurses }:

stdenv.mkDerivation rec {
  pname = "imgcat";
  version = "2.5.1";

  buildInputs = [ ncurses cimg ];

  preConfigure = ''
    sed -i -e "s|-ltermcap|-L ${ncurses}/lib -lncurses|" Makefile
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  src = fetchFromGitHub {
    owner = "eddieantonio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-EkVE6BgoA1lo4oqlNETTxLILIVvGXspFyXykxpmYk8M=";
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  meta = with lib; {
    description = "It's like cat, but for images";
    homepage = "https://github.com/eddieantonio/imgcat";
    license = licenses.isc;
    maintainers = with maintainers; [ jwiegley ];
    platforms = platforms.unix;
  };
}

