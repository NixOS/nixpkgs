{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  sqlcmd,
  testers,
}:

buildGoModule (finalAttrs: {
  pname = "sqlcmd";
  version = "1.10.0";

  src = fetchFromGitHub {
    repo = "go-sqlcmd";
    owner = "microsoft";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-FZJiIC8rhZGE0nLY81GUHVXouvhNbx5gj+Xy2z8uxjw=";
  };

  vendorHash = "sha256-y2AuRgi8o2ttGkBI/rUEtMbcoIj/BvpVdSVamDbaCpo=";
  proxyVendor = true;

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/modern" ];

  nativeBuildInputs = [ installShellFiles ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  postInstall = ''
    mv $out/bin/modern $out/bin/sqlcmd

    installShellCompletion --cmd sqlcmd \
      --bash <($out/bin/sqlcmd completion bash) \
      --fish <($out/bin/sqlcmd completion fish) \
      --zsh <($out/bin/sqlcmd completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = sqlcmd;
    command = "sqlcmd --version";
    inherit (finalAttrs) version;
  };

  meta = {
    description = "Command line tool for working with Microsoft SQL Server, Azure SQL Database, and Azure Synapse";
    mainProgram = "sqlcmd";
    homepage = "https://github.com/microsoft/go-sqlcmd";
    changelog = "https://github.com/microsoft/go-sqlcmd/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.ratsclub ];
  };
})
