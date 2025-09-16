{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "poutine";
  version = "0.15.2";

  src = fetchFromGitHub {
    owner = "boostsecurityio";
    repo = "poutine";
    tag = "v${version}";
    hash = "sha256-YBoGsexYT2/lAWEajMVa/xNRBv1R1i0hB6pTAlk43E0=";
  };

  vendorHash = "sha256-CZLzIGu6jj4JXmKJaWmyeRvcRNjBYecblW47kcsg5Nw=";

  ldflags = [
    "-s"
    "-w"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd ${meta.mainProgram} \
      --bash <($out/bin/${meta.mainProgram} completion bash) \
      --fish <($out/bin/${meta.mainProgram} completion fish) \
      --zsh <($out/bin/${meta.mainProgram} completion zsh)
  '';

  meta = {
    description = "Security scanner that detects misconfigurations and vulnerabilities in build pipelines of repositories";
    homepage = "https://github.com/boostsecurityio/poutine";
    changelog = "https://github.com/boostsecurityio/poutine/releases/tag/v${version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "poutine";
    broken = stdenv.hostPlatform.isDarwin;
  };
}
