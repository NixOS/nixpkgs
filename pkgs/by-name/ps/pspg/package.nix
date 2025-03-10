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
  version = "5.8.8";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = pname;
    rev = version;
    sha256 = "sha256-8Wi8fMEBc1A0foEzwO5Dq6c3yC0pJ9hbzCjjMp+Lapg=";
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
