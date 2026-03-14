{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
  writableTmpDirAsHomeHook,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "agent-browser";
  version = "0.20.0";

  src = fetchFromGitHub {
    owner = "vercel-labs";
    repo = "agent-browser";
    tag = "v${finalAttrs.version}";
    hash = "sha256-04Y3OUiCfuIimO0KmF7VPFG3REvqD+nq7QprnuIZwKE=";
  };

  sourceRoot = "${finalAttrs.src.name}/cli";

  cargoHash = "sha256-7l/2Q1P5JIC+kp0Pm729LBXXHVDt//Xe1cieWHjcvdc=";

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  # skills/ contains SKILL.md for tools like Claude Code.
  postInstall = ''
    mkdir -p $out/lib/agent-browser
    cp -r ../skills $out/lib/agent-browser/
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
