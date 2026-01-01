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
<<<<<<< HEAD
  version = "5.8.14";
=======
  version = "5.8.12";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "okbob";
    repo = "pspg";
    rev = version;
<<<<<<< HEAD
    sha256 = "sha256-DZsMZZO5NMutlzLT+wwtPNdnzAnka32ZMqgMvEuw9ag=";
=======
    sha256 = "sha256-TLHGMqrKqWQ7ccnPFV9N6FuF+ZeOGjhuiS1X8W8kW/4=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

<<<<<<< HEAD
  meta = {
    homepage = "https://github.com/okbob/pspg";
    description = "Postgres Pager";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.unix;
    maintainers = [ lib.maintainers.jlesquembre ];
=======
  meta = with lib; {
    homepage = "https://github.com/okbob/pspg";
    description = "Postgres Pager";
    license = licenses.bsd2;
    platforms = platforms.unix;
    maintainers = [ maintainers.jlesquembre ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
    mainProgram = "pspg";
  };
}
