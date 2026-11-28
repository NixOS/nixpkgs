{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  bash,
  makeWrapper,
  installShellFiles,
  python3,
  curl,
  coreutils,
  libnotify,
  nix-update-script,
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "peon-ping";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "PeonPing";
    repo = "peon-ping";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vndfP+fMS7FnDDQBS0UV6ZNg46Rno9E48DbYhoktYrw=";
  };

  nativeBuildInputs = [
    makeWrapper
    installShellFiles
  ];

  buildInputs = [ bash ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm755 peon.sh $out/lib/peon-ping/peon.sh
    install -Dm644 config.json $out/lib/peon-ping/config.json

    makeWrapper $out/lib/peon-ping/peon.sh $out/bin/peon \
      --prefix PATH : ${
        lib.makeBinPath [
          coreutils
          curl
          libnotify
          python3
        ]
      }

    installShellCompletion --cmd peon \
      --bash completions.bash \
      --fish completions.fish

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Notification sound player for AI coding agents";
    longDescription = ''
      peon-ping plays game character voice lines when AI coding agents
      (Claude Code, Cursor, Codex, etc.) need your attention. It supports
      desktop and mobile notifications, multiple sound packs, and integrates
      as hooks in IDE configurations.

      Sound packs must be installed separately into
      ~/.claude/hooks/peon-ping/packs/ — see the project README for details.
    '';
    homepage = "https://github.com/PeonPing/peon-ping";
    changelog = "https://github.com/PeonPing/peon-ping/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ workflow ];
    platforms = lib.platforms.linux;
    mainProgram = "peon";
  };
})
