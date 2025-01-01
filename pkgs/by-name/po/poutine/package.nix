{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "poutine";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "boostsecurityio";
    repo = "poutine";
    rev = "refs/tags/v${version}";
    hash = "sha256-9vbK2tc57e/YNfhSVbCMxnzOmmahr9T3x5Tt7GQjVnc=";
  };

  vendorHash = "sha256-HYuyGSatUOch73IKc7/9imhwz0Oz6Mrccs2HKVQtaVE=";

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

  meta = with lib; {
    description = "Security scanner that detects misconfigurations and vulnerabilities in build pipelines of repositories";
    homepage = "https://github.com/boostsecurityio/poutine";
    changelog = "https://github.com/boostsecurityio/poutine/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
    mainProgram = "poutine";
  };
}
