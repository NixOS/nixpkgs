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
  version = "1.0.0-unstable-2026-07-09";

  src = fetchFromGitHub {
    owner = "unixorn";
    repo = "fzf-zsh-plugin";
    rev = "92187cbc8fe91b7c5ab3a186e566682f64286879";
    hash = "sha256-JedEqrcaJmVL8PF850xP7csgvFzDpcCqW8lJ/5WHklY=";
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
