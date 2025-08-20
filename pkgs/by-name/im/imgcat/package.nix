{
  lib,
  stdenv,
  fetchFromGitHub,
  cimg,
  ncurses,
}:

stdenv.mkDerivation rec {
  pname = "imgcat";
  version = "2.6.0";

  buildInputs = [
    ncurses
    cimg
  ];

  preConfigure = ''
    sed -i -e "s|-ltermcap|-L ${ncurses}/lib -lncurses|" Makefile
  '';

  makeFlags = [ "PREFIX=$(out)" ];

  src = fetchFromGitHub {
    owner = "eddieantonio";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-miFjlahTI0GDpgsjnA/K1R4R5654M8AoK78CycoLTqA=";
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  meta = with lib; {
    description = "It's like cat, but for images";
    homepage = "https://github.com/eddieantonio/imgcat";
    license = licenses.isc;
    maintainers = with maintainers; [ jwiegley ];
    platforms = platforms.unix;
    mainProgram = "imgcat";
  };
}
