{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "ory";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "ory";
    repo = "cli";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WqVcVqdgzlI6OvgLA4OViBsU0DGaTnv5F+Ew58UzQlM=";
  };

  nativeBuildInputs = [
    installShellFiles
  ];

  subPackages = [ "." ];

  env.CGO_ENABLED = 1;

  tags = [
    "sqlite"
  ];

  vendorHash = "sha256-W7yi6CSioLnLmOsK7hdB3C96fV7METOe+wzKKMWpphw=";
  postInstall = ''
    mv $out/bin/cli $out/bin/ory
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    export version=v${finalAttrs.version}
    installShellCompletion --cmd ory \
      --bash <($out/bin/ory completion bash) \
      --fish <($out/bin/ory completion fish) \
      --zsh <($out/bin/ory completion zsh)
  '';

  meta = {
    description = "CLI for Ory";
    mainProgram = "ory";
    homepage = "https://www.ory.sh/cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      luleyleo
      nicolas-goudry
    ];
  };
})
