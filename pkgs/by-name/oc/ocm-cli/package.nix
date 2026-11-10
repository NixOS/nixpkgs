{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

buildGoModule (finalAttrs: {
  __structuredAttrs = true;

  pname = "ocm-cli";
  version = "0.53.0";

  src = fetchFromGitHub {
    owner = "open-component-model";
    repo = "ocm";
    tag = "v${finalAttrs.version}";
    hash = "sha256-BJ1tbAM/+78sx/ihJ4T8C8eNEQBtm53uZ6TTYxMcJD4=";
  };

  vendorHash = "sha256-+rAOvHUq/E8d38iSce/9yW8esKD4Q/4EZ33+3JW9YcM=";

  subPackages = [
    "cmds/ocm"
    "cmds/cliplugin"
    "cmds/demoplugin"
    "cmds/ecrplugin"
    "cmds/subcmdplugin"
    "cmds/jfrogplugin"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/open-component-model/ocm/pkg/version.version=${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ocm \
      --bash <($out/bin/ocm completion bash) \
      --zsh <($out/bin/ocm completion zsh) \
      --fish <($out/bin/ocm completion fish)
  '';

  meta = {
    description = "Open Component Model (OCM) is an open standard to describe software bills of delivery (SBOD)";
    longDescription = ''
      OCM is a technology-agnostic and machine-readable format focused on the software artifacts that must be delivered for software products.
      The specification is also used to express metadata needed for security, compliance, and certification purpose.
    '';
    homepage = "https://ocm.software";
    changelog = "https://github.com/open-component-model/ocm/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ h0nIg ];
    mainProgram = "ocm";
    platforms = lib.platforms.unix;
  };
})
