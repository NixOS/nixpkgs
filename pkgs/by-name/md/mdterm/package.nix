{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mdterm";
  version = "2.0.0";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "bahdotsh";
    repo = "mdterm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-a4Ba5QdrLuLgfB/QVpUYEpQ6rRSqTdz8zXcLwOGzjJM=";
  };

  cargoHash = "sha256-YUPKUFfbzL/1peXEAX5EDehWq4hFwxJLkP2DBDkY23E=";

  meta = {
    description = "A terminal-based Markdown browser";
    homepage = "https://github.com/bahdotsh/mdterm";
    changelog = "https://github.com/bahdotsh/mdterm/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    mainProgram = "mdterm";
    maintainers = with lib.maintainers; [ pborzenkov ];
  };
})
