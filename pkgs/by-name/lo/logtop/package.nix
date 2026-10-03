{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  uthash,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "logtop";
  version = "0.7";

  src = fetchFromGitHub {
    rev = "logtop-${finalAttrs.version}";
    owner = "JulienPalard";
    repo = "logtop";
    hash = "sha256-IkQ817YEuI+6vlQ7uvWziv/Na5dofD4B273R5V+aG7k=";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    ncurses
    uthash
  ];

  makeFlags = [ "CC=${stdenv.cc.targetPrefix}cc" ];
  installFlags = [ "DESTDIR=$(out)" ];

  postConfigure = ''
    substituteInPlace Makefile --replace /usr ""
  '';

  meta = {
    description = "Displays a real-time count of strings received from stdin";
    longDescription = ''
      logtop displays a real-time count of strings received from stdin.
      It can be useful in some cases, like getting the IP flooding your
      server or the top buzzing article of your blog
    '';
    license = lib.licenses.bsd2;
    homepage = "https://github.com/JulienPalard/logtop";
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.starcraft66 ];
    mainProgram = "logtop";
  };
})
