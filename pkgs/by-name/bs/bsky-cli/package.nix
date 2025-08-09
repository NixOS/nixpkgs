{
  lib,
  buildGoModule,
  fetchFromGitHub,
  libpcap,
  versionCheckHook,
  nix-update-script,
}:
buildGoModule (finalAttrs: {
  pname = "bsky-cli";
  version = "0.0.74";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "bsky";
    tag = "v${finalAttrs.version}";
    hash = "sha256-pLgPQYL4+BErqRe09Pj94gLt/OoxEt9r4n+gZtZSS4Y=";
  };

  vendorHash = "sha256-f9LZHJ5yXWUUh6HdF2JPEBucWuVud3YX5l2MkHs6UXc=";

  buildInputs = [
    libpcap
  ];

  ldflags = [
    "-s"
    "-w"
  ];

  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/bsky";
  versionCheckProgramArg = "--version";
  nativeBuildInputs = [ versionCheckHook ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Cli application for bluesky social";
    homepage = "https://github.com/mattn/bsky";
    changelog = "https://github.com/mattn/bsky/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ isabelroses ];
    mainProgram = "bsky";
  };
})
