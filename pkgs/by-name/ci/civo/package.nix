{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "civo";
  version = "1.4.3";

  src = fetchFromGitHub {
    owner = "civo";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-0F8RF2vbuuLv39yIYQk7TdBw8CImcnMFQ9r+GSHGGiY=";
  };

  vendorHash = "sha256-TsaGXDUTvTsfDIBhM9+JwL2swEw/qSivn3NTA0tWkZw=";

  nativeBuildInputs = [ installShellFiles ];

  env.CGO_ENABLED = 0;

  # Some lint checks fail
  doCheck = false;

  ldflags = [
    "-s"
    "-X github.com/civo/cli/common.VersionCli=${version}"
    "-X github.com/civo/cli/common.CommitCli=${src.rev}"
    "-X github.com/civo/cli/common.DateCli=unknown"
  ];

  doInstallCheck = false;

  postInstall = ''
    mv $out/bin/cli $out/bin/civo
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd civo \
      --bash <($out/bin/civo completion bash) \
      --fish <($out/bin/civo completion fish) \
      --zsh <($out/bin/civo completion zsh)
  '';

  meta = {
    description = "CLI for interacting with Civo resources";
    mainProgram = "civo";
    homepage = "https://github.com/civo/cli";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      techknowlogick
      rytswd
    ];
  };
}
