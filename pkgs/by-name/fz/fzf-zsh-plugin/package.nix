{
  bash,
  stdenv,
  lib,
  fetchFromGitHub,
  zsh,
}:

stdenv.mkDerivation {
  pname = "fzf-zsh-plugin";
  version = "1.0.0-unstable-2025-12-15";

  src = fetchFromGitHub {
    owner = "unixorn";
    repo = "fzf-zsh-plugin";
    rev = "cdd9d5cc3b41a3a390a0fb8605c40de652da6309";
    hash = "sha256-i6qoaMWVofhD3K6/RaaNatzA2aokiNQ5ilqmahprJFU=";
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

  meta = {
    homepage = "https://github.com/unixorn/fzf-zsh-plugin";
    description = "ZSH plugin to enable fzf searches of a lot more stuff - docker, tmux, homebrew and more";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.eymeric ];
    platforms = lib.platforms.all;
  };
}
