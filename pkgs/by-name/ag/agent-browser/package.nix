{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "agent-browser";
  version = "0.23.3";

  src = fetchFromGitHub {
    owner = "vercel-labs";
    repo = "agent-browser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Q02sJr14zRrVrRJ0M30AD0EG7DGkYtafCH6/kI15/xk=";
  };

  sourceRoot = "${finalAttrs.src.name}/cli";

  cargoHash = "sha256-smJ+ODr88moz+16G9fXSz/NNiGngWeoTuQtBn21qu1s=";

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  __darwinAllowLocalNetworking = true;

  # skills/ contains SKILL.md for tools like Claude Code
  postInstall = ''
    mkdir -p $out/share/agent-browser
    cp -r ../skills $out/share/agent-browser/
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Headless browser automation CLI for AI agents";
    homepage = "https://github.com/vercel-labs/agent-browser";
    license = lib.licenses.asl20;
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [ codgician ];
    mainProgram = "agent-browser";
  };
})
