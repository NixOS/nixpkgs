{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

buildGoModule rec {
  pname = "glow";
  version = "2.1.1";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "glow";
    rev = "v${version}";
    hash = "sha256-lDGCRtwCpW/bZlfcb100g7tMXN2dlCPnCY7qVFyayUo=";
  };

  vendorHash = "sha256-JqQnLwkxRt+CiP90F+1i4MAiOw3akMQ5BeQXCplZdxA=";

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${version}"
  ];

  doCheck = false;

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd glow \
      --bash <($out/bin/glow completion bash) \
      --fish <($out/bin/glow completion fish) \
      --zsh <($out/bin/glow completion zsh)
  '';

  meta = {
    description = "Render markdown on the CLI, with pizzazz";
    homepage = "https://github.com/charmbracelet/glow";
    changelog = "https://github.com/charmbracelet/glow/releases/tag/v${version}";
    license = lib.licenses.mit;
    mainProgram = "glow";
  };
}
