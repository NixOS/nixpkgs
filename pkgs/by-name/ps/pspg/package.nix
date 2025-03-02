{
  lib,
  stdenv,
  fetchFromGitHub,
  gnugrep,
  ncurses,
  pkg-config,
  installShellFiles,
  readline,
  libpq,
}:

stdenv.mkDerivation rec {
  pname = "pspg";
  version = "5.8.7";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = pname;
    rev = version;
    sha256 = "sha256-SE+62EODKWcKFpMMbWDw+Dp5b2D/XKbMFiJiD/ObrhU=";
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];
  buildInputs = [
    gnugrep
    libpq
    ncurses
    readline
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postInstall = ''
    installManPage pspg.1
    installShellCompletion --bash --cmd pspg bash-completion.sh
  '';

  meta = with lib; {
    homepage = "https://github.com/okbob/pspg";
    description = "Postgres Pager";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.jlesquembre ];
    mainProgram = "pspg";
  };
}
