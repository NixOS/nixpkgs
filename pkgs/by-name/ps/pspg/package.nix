{
  lib,
  stdenv,
  fetchFromGitHub,
  gnugrep,
  ncurses,
  pkg-config,
  installShellFiles,
  readline,
  postgresql,
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
    ncurses
    readline
    postgresql
  ];

  makeFlags = [ "PREFIX=${placeholder "out"}" ];

  postInstall = ''
    installManPage pspg.1
    installShellCompletion --bash --cmd pspg bash-completion.sh
  '';

  meta = {
    homepage = "https://github.com/okbob/pspg";
    description = "Postgres Pager";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.jlesquembre ];
    mainProgram = "pspg";
  };
}
