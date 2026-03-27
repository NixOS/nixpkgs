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
  version = "0.0.77";

  src = fetchFromGitHub {
    owner = "mattn";
    repo = "bsky";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cO2Ub9DVkDcz9+x+EskJsfgJ3xnTba5rWYsxmXfQ2a0=";
  };

  vendorHash = "sha256-WFGViuC+8Ba6NCU//Z+MTcwNPJbYzpXeCbf4M9mBFPM=";

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
