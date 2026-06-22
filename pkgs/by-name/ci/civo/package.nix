{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "civo";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "civo";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Zpi7vwjabxOsfgV7JJPlovldrZsuu2BR+ltNBLF8kvw=";
  };

  vendorHash = "sha256-I2vnXpunc8/ApTE4Q5xcMEXea9LdefZijM/G9hswkws=";

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
