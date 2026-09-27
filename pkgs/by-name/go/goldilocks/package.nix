{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "goldilocks";
  version = "4.15.1";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = "goldilocks";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ubfhj9pYSFpfWkYO1LkA+sW8wwh/dDgQnH91GhKMwKA=";
  };

  vendorHash = "sha256-dtVNxumYkzWihfI42R7LuXLGtELg5EnxH9FUMCL4u/4=";

  __structuredAttrs = true;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];
  versionCheckProgramArg = "version";

  meta = {
    description = "Get your resource requests \"Just Right\"";
    longDescription = ''
      Goldilocks is a utility that can help you identify a starting point for
      resource requests and limits. By using the Kubernetes
      VerticalPodAutoscaler in recommendation mode, it gives you a dashboard
      with suggested resource requests and limits for each workload, so you can
      set them "just right".
    '';
    homepage = "https://goldilocks.docs.fairwinds.com/";
    changelog = "https://github.com/FairwindsOps/goldilocks/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ELHart05 ];
    mainProgram = "goldilocks";
  };
})
