{
  lib,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "replaySh";
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "Ra77a3l3-jar";
    repo = "replaySh";
    tag = "v${finalAttrs.version}";
    hash = "sha256-nSOS6lCOCnsS0drD2GOBcm3r5OAhv/bE6gjhQA5zBIo=";
  };

  cargoHash = "sha256-aMaXnDNHHBtmbm9jFCM24sBzRA4z6DNLd1vJZBOYaSw=";

  __structuredAttrs = true;

  nativeBuildInputs = [ installShellFiles ];

  doCheck = true;

  postInstall = ''
    export HOME=$(mktemp -d)
    $out/bin/replay completions --install bash
    $out/bin/replay completions --install fish
    $out/bin/replay completions --install zsh
    installShellCompletion --bash "$HOME/.local/share/bash-completion/completions/replay"
    installShellCompletion --fish "$HOME/.config/fish/completions/replay.fish"
    installShellCompletion --zsh "$HOME/.local/share/zsh/site-functions/_replay"
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Record once, replay forever — a CLI workflow recorder and replayer";
    homepage = "https://github.com/Ra77a3l3-jar/replaySh";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ Ra77a3l3-jar ];
    mainProgram = "replay";
  };
})
