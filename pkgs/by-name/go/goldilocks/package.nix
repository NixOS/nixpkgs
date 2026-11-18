{
  lib,
  buildGoModule,
  fetchFromGitHub,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "goldilocks";
  version = "4.16.3";

  src = fetchFromGitHub {
    owner = "FairwindsOps";
    repo = "goldilocks";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WeYpAbDPf1eal3m3n0AnpeN2mTqcjzWuMWXf9uZie8A=";
  };

  vendorHash = "sha256-SIqPB2W1vScH2r6OYD6qVecTdzhtyIaFM2gsHrocIOY=";

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
