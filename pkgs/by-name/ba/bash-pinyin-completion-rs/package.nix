{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bash-pinyin-completion-rs";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "AOSC-Dev";
    repo = "bash-pinyin-completion-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TBTVUDtlBCvfmWcwcSr9xLXE1cBLHeptklwR3hD+49Y=";
  };

  strictDeps = true;

  cargoHash = "sha256-DmFsRoguommcBbeJrCcTRm815c7gLnUQ+7n0/Iz6Gvk=";

  postInstall = ''
    substituteInPlace scripts/bash_pinyin_completion \
      --replace-fail 'bash-pinyin-completion-rs' "$out/bin/bash-pinyin-completion-rs" \
      --replace-fail '#!/usr/bin/env bash' ""
    install -Dm644 scripts/bash_pinyin_completion $out/etc/bash_completion.d/pinyin_completion.bash
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Simple completion script for pinyin, written in rust";
    homepage = "https://github.com/AOSC-Dev/bash-pinyin-completion-rs";
    changelog = "https://github.com/AOSC-Dev/bash-pinyin-completion-rs/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ moraxyc ];
    mainProgram = "bash-pinyin-completion-rs";
  };
})
