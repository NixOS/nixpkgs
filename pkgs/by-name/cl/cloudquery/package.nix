{
  lib,
  buildGoModule,
  fetchFromGitHub,
  nix-update-script,
  installShellFiles,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "cloudquery";
  version = "6.42.3";
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "cloudquery";
    repo = "cloudquery";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MHZXnS6quXImSJ78+cy5bpL82WmjQRa/HPcg5QPt4OE=";
  };

  modRoot = "cli";

  vendorHash = "sha256-F8iQmZ0n/rPmcDO+3SNLC4s4CRB/0HA45pGM+Nf6g2g=";

  subPackages = [
    "."
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/cloudquery/cloudquery/cli/v${lib.versions.major finalAttrs.version}/cmd.Version=${finalAttrs.version}"
  ];

  doInstallCheck = true;

  nativeBuildInputs = [
    installShellFiles
    versionCheckHook
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/cloudquery

    installShellCompletion --cmd cloudquery \
       --bash <($out/bin/cloudquery completion bash) \
       --fish <($out/bin/cloudquery completion fish) \
       --zsh <($out/bin/cloudquery completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Data pipelines for cloud config and security data";
    homepage = "https://github.com/cloudquery/cloudquery";
    changelog = "https://github.com/cloudquery/cloudquery/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ jlesquembre ];
    mainProgram = "cloudquery";
  };
})
