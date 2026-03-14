{
  lib,
  stdenv,
  fetchFromGitHub,
  installShellFiles,
  openssh,
  tmux,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "hostmux";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "hukl";
    repo = "hostmux";
    rev = finalAttrs.version;
    hash = "sha256-Rh8eyKoUydixj+X7muWleZW9u8djCQAyexIfRWIOr0o=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  buildInputs = [
    openssh
    tmux
  ];

  postPatch = ''
    substituteInPlace hostmux \
      --replace "SSH_CMD=ssh" "SSH_CMD=${lib.getExe openssh}" \
      --replace "TMUX_CMD=tmux" "TMUX_CMD=${lib.getExe tmux}"
  '';

  installPhase = ''
    runHook preInstall

    install -Dm755 hostmux $out/bin/hostmux
    installManPage man/hostmux.1
    installShellCompletion --zsh zsh-completion/_hostmux

    runHook postInstall
  '';

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Small wrapper script for tmux to easily connect to a series of hosts via ssh and open a split pane for each of the hosts";
    homepage = "https://github.com/hukl/hostmux";
    changelog = "https://github.com/hukl/hostmux/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "hostmux";
    maintainers = with lib.maintainers; [ fernsehmuell ];
    platforms = lib.platforms.unix;
  };
})
