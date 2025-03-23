{
  lib,
  stdenv,
  fetchFromGitHub,
  ncurses,
  uthash,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "logtop";
  version = "0.7";

  src = fetchFromGitHub {
    rev = "logtop-${version}";
    owner = "JulienPalard";
    repo = "logtop";
    sha256 = "1f8vk9gybldxvc0kwz38jxmwvzwangsvlfslpsx8zf04nvbkqi12";
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

  meta = with lib; {
    description = "Displays a real-time count of strings received from stdin";
    longDescription = ''
      logtop displays a real-time count of strings received from stdin.
      It can be useful in some cases, like getting the IP flooding your
      server or the top buzzing article of your blog
    '';
    license = licenses.bsd2;
    homepage = "https://github.com/JulienPalard/logtop";
    platforms = platforms.unix;
    maintainers = [ maintainers.starcraft66 ];
    mainProgram = "logtop";
  };
}
