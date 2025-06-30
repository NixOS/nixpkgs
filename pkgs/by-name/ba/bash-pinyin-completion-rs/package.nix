{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "bash-pinyin-completion-rs";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "AOSC-Dev";
    repo = "bash-pinyin-completion-rs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-h4l4plGMn5WMhU60+m60Uf45UfPNDb0X+E2LK3U3jxw=";
  };

  strictDeps = true;

  cargoHash = "sha256-SAegFsmn91xrWg0o7lHgk+vRqTQhabev9dP+Lbk/h5s=";

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
