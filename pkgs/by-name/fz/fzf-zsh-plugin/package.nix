{
  bash,
  stdenv,
  lib,
  fetchFromGitHub,
  unstableGitUpdater,
  zsh,
}:

stdenv.mkDerivation {
  pname = "fzf-zsh-plugin";
  version = "1.0.0-unstable-2026-06-21";

  src = fetchFromGitHub {
    owner = "unixorn";
    repo = "fzf-zsh-plugin";
    rev = "70e2ac8a12c137c1b097a6ecfdc0236e5ef51d1b";
    hash = "sha256-qwqezNXBRFKTWyMp+9Ss2hEAU9Bznc/DK0XNGZOfVOE=";
  };

  strictDeps = true;

  buildInputs = [
    bash
    zsh
  ];

  installPhase = ''
    runHook preInstall
    install -D fzf-settings.zsh $out/share/zsh/fzf-zsh-plugin/fzf-settings.zsh
    install -D fzf-zsh-plugin.plugin.zsh $out/share/zsh/fzf-zsh-plugin/fzf-zsh-plugin.plugin.zsh
    mkdir -p $out/bin
    cp -r bin/* $out/bin/
    runHook postInstall
  '';

  passthru.updateScript = unstableGitUpdater { tagPrefix = "v"; };

  meta = {
    homepage = "https://github.com/unixorn/fzf-zsh-plugin";
    description = "ZSH plugin to enable fzf searches of a lot more stuff - docker, tmux, homebrew and more";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.eymeric ];
    platforms = lib.platforms.all;
  };
}
