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
  version = "1.0.0-unstable-2026-06-30";

  src = fetchFromGitHub {
    owner = "unixorn";
    repo = "fzf-zsh-plugin";
    rev = "6f953534d4c69a7340d27b7dcf14f406a22bed61";
    hash = "sha256-RQrxCU7f3LSepUYm0+2ljvJfzVh8yp4NMJHxssA60Vk=";
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
