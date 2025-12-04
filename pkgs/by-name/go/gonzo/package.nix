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
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "control-theory";
    repo = "gonzo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-NoZDSKdFb805WjtXLwA8/bnbTdJgnCtFxk6FqbuEo/0=";
  };

  vendorHash = "sha256-XKwtq8EF774lHLHtyFzveFa5agJa15CvhsuwwaQdJwU=";

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
  versionCheckProgramArg = "--version";

  meta = {
    description = "TUI log analysis tool";
    homepage = "https://gonzo.controltheory.com/";
    downloadPage = "https://github.com/control-theory/gonzo";
    changelog = "https://github.com/control-theory/gonzo/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "gonzo";
  };
})
