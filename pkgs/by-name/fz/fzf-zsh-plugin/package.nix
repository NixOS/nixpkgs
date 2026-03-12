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
  version = "1.0.0-unstable-2026-03-03";

  src = fetchFromGitHub {
    owner = "unixorn";
    repo = "fzf-zsh-plugin";
    rev = "d56d2387ce376f80e42c46654a9ee1f899a40b46";
    hash = "sha256-twry9z9gDvRfH3AOWEV/a9HX4pnlMJDSw74Sm/MBwIk=";
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
