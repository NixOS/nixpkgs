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
  version = "0.0.76";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "bsky";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R8cKWVNk5gXj+wd0d1ZYSkxuXToXB2UZJsF7sCYGMqw=";
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
