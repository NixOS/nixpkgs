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
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "control-theory";
    repo = "gonzo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EpmpMFdFx56+4N9b2pps6KSXYCjew/lcKeKMNPwprw8=";
  };

  vendorHash = "sha256-DDLm6erM3UutEyXA/5Utt3T5Gr128gxHowyWgcG0llw=";

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
    changelog = "https://github.com/control-theory/gonzo/releases/tag/v${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kpbaks ];
    mainProgram = "gonzo";
  };
})
