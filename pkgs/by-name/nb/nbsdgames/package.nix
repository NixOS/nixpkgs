{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  pkg-config,
  ncurses,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "nbsdgames";
  version = "5-unstable-2023-03-13";

  src = fetchFromGitHub {
    owner = "abakh";
    repo = "nbsdgames";
    rev = "b7530749f7d7cc1aba9dcf202543ed6f638592f8";
    hash = "sha256-/GK2FVV/JKh+bU/FSnY6Hr3PWxSr5CW8XerfGF+FPls=";
  };

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [ ncurses ];

  installFlags = [
    "DESTDIR=$(out)"
    "PREFIX="
    "GAMES_DIR=bin"
  ];

  preInstall = ''
    mkdir -p $out/bin
  '';

  postInstall = ''
    installManPage man/*
  '';

  meta = {
    description = "Package of 18 text-based modern games";
    homepage = "https://github.com/abakh/nbsdgames";
    license = lib.licenses.cc0;
    maintainers = with lib.maintainers; [ sarcasticadmin ];
    mainProgram = "nbsdgames";
    platforms = lib.platforms.all;
  };
})
