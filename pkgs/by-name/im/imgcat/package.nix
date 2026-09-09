{
  lib,
  stdenv,
  fetchFromGitHub,
  cimg,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
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
    repo = "imgcat";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-miFjlahTI0GDpgsjnA/K1R4R5654M8AoK78CycoLTqA=";
  };

  env.NIX_CFLAGS_COMPILE = "-Wno-error";

  meta = {
    description = "It's like cat, but for images";
    homepage = "https://github.com/eddieantonio/imgcat";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ jwiegley ];
    platforms = lib.platforms.unix;
    mainProgram = "imgcat";
  };
})
