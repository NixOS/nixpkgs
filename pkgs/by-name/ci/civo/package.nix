{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "civo";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "civo";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-rKDY4AF43cWdrQEEu0go6LXt+6jUawUgJshg4tg5yv0=";
  };

  vendorHash = "sha256-3SULs0LKzJQ2NZYINHRHRoirYqTDdvTWz2o1PZ/Vd6g=";

  nativeBuildInputs = [ installShellFiles ];

  env.CGO_ENABLED = 0;

  # Some lint checks fail
  doCheck = false;

  ldflags = [
    "-s"
    "-X github.com/civo/cli/common.VersionCli=${finalAttrs.version}"
    "-X github.com/civo/cli/common.CommitCli=${finalAttrs.src.rev}"
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
})
