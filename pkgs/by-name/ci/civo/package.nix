{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "civo";
<<<<<<< HEAD
  version = "1.4.7";
=======
  version = "1.4.6";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "civo";
    repo = "cli";
    rev = "v${version}";
<<<<<<< HEAD
    hash = "sha256-eR/L0AkeMgtbtaV+jIhbyGN1tUYrpnIWDeKD0p9BP1Y=";
  };

  vendorHash = "sha256-F56+450hDqAiIFt9/Jl79ltLOKMRC2NaNQM4/T4Di3k=";
=======
    hash = "sha256-QZZuRHcKNncQTRgizWAH723OskVMH92eQ72wHpEINEc=";
  };

  vendorHash = "sha256-ZoJdu8sA0r5kiADF+VB4BnOduWLbBAVGbMQs45HKDIU=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

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
