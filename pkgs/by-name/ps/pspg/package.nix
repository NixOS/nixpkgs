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

stdenv.mkDerivation (finalAttrs: {
  pname = "pspg";
  version = "5.9.0";

  src = fetchFromGitHub {
    owner = "okbob";
    repo = "pspg";
    rev = finalAttrs.version;
    sha256 = "sha256-LcQnsSlaBvBCqg/fEj6xhzvVs6qZe73bT61Fz707XpM=";
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

  meta = {
    homepage = "https://github.com/okbob/pspg";
    description = "Postgres Pager";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.jlesquembre ];
    mainProgram = "pspg";
  };
})
