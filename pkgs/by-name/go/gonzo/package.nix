{
  lib,
  go,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "gonzo";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "control-theory";
    repo = "gonzo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-N38gBEe2VZiUtnffzROv9GAwXp0lMyaNj/ywtNlbmjY=";
  };

  vendorHash = "sha256-8ATB57qiEc6ANBrt1mbqtsFQlIO9p3b4qdZX2ua7EMY=";

  ldflags = [
    "-s"
    "-w"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.src.tag}"
    "-X=main.buildTime=1970-01-01T00:00:00Z"
    "-X=main.goVersion=${lib.getVersion go}"
  ];

  passthru.updateScript = nix-update-script { };

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  meta = {
    description = "TUI log analysis tool";
    homepage = "https://gonzo.controltheory.com/";
    downloadPage = "https://github.com/control-theory/gonzo";
    changelog = "https://github.com/control-theory/gonzo/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "gonzo";
  };
})
