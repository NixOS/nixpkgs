{
  lib,
  fetchFromGitHub,
  rustPlatform,
  versionCheckHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "markless";
  version = "0.9.29";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "jvanderberg";
    repo = "markless";
    tag = "v${finalAttrs.version}";
    hash = "sha256-orjJ++948WEJ031c5Dcvmfyqw2JMRJRjoBsGU+A+B4w=";
  };

  cargoHash = "sha256-kMMglmIsc3HkCx24Zir3NtZitwrxYwa7FgLgAZ2/ffo=";

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Terminal markdown viewer with image support";
    longDescription = ''
      Markless is a terminal markdown viewer and editor focused on fast
      navigation, clear rendering, and sensible defaults for long documents.

      Features include: markdown rendering (headings, lists, tables, block
      quotes, code blocks, footnotes, task lists), syntax-highlighted code
      blocks, inline images (Kitty, Sixel, iTerm2, and half-block fallback),
      Mermaid diagram rendering, LaTeX math via Typst, CSV rendering as
      tables, binary hex dump, built-in editor mode, directory browse mode,
      table of contents sidebar, incremental search, file watching for live
      reload, and auto theme detection.
    '';
    homepage = "https://github.com/jvanderberg/markless";
    changelog = "https://github.com/jvanderberg/markless/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "markless";
    maintainers = with lib.maintainers; [ fraggerfox ];
    platforms = lib.platforms.unix;
  };
})
