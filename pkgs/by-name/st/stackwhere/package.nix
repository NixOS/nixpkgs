{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "stackwhere";
  version = "0.4.0";

  __structuredAttrs = true;
  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "cilium";
    repo = "stackwhere";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ofg0ibDG7QI5eESvKl1U8SNq8567aSo79/Iiuj2UaoM=";
  };

  vendorHash = "sha256-J2X1uTkRtmdmo8Fxxql6Nu84F6MarWHFTopavUPL+RU=";

  ldflags = [
    "-s"
    "-X=main.version=${finalAttrs.version}"
    "-X=main.commit=${finalAttrs.version}"
    "-X=main.date=1970-01-01T00:00:00Z"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool for exploring where BPF stack usage comes from";
    homepage = "https://github.com/cilium/stackwhere";
    changelog = "https://github.com/cilium/stackwhere/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ stepbrobd ];
    mainProgram = "stackwhere";
  };
})
