{ lib, stdenv, fetchFromGitHub, cimg, ncurses }:

stdenv.mkDerivation rec {
  pname = "imgcat";
  version = "2.5.2";

  buildInputs = [ ncurses cimg ];

  preConfigure = ''
    sed -i -e "s|-ltermcap|-L ${ncurses}/lib -lncurses|" Makefile
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  src = fetchFromGitHub {
    owner = "eddieantonio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-61xIB/Fa+Utu694aITzBoMQeYa0Trh5L0oIKp8Be+D0=";
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

