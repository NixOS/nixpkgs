{
  lib,
  stdenv,
  fetchzip,
  installShellFiles,
}:

stdenv.mkDerivation rec {
  pname = "detach";
  version = "0.2.3";

  src = fetchzip {
    url = "http://inglorion.net/download/detach-${version}.tar.bz2";
    hash = "sha256-nnhJGtmPlTeqM20FAKRyhhSMViTXFpQT0A1ol4lhsoc=";
  };

  nativeBuildInputs = [ installShellFiles ];

  dontConfigure = true;

  makeFlags = [ "PREFIX=$(out)" ];

  postInstall = ''
    installShellCompletion --cmd detach \
      --zsh contrib/zsh-completer/_detach
  '';

  doCheck = false;

  meta = {
    description = "Utility for running a command detached from the current terminal";
    homepage = "https://inglorion.net/software/detach/";
    license = lib.licenses.mit;
    mainProgram = "detach";
    maintainers = with lib.maintainers; [ pbsds ];
    platforms = lib.platforms.unix;
  };
}
