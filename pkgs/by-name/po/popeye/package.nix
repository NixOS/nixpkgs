{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "popeye";
  version = "0.21.7";

  src = fetchFromGitHub {
    rev = "v${version}";
    owner = "derailed";
    repo = "popeye";
    sha256 = "sha256-8X/L9je5TaxSx/RtPQlO/6CKd+zUIxFBfTDrNZAA2fU=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X github.com/derailed/popeye/cmd.version=${version}"
    "-X github.com/derailed/popeye/cmd.commit=${version}"
  ];

  vendorHash = "sha256-JX9afHS76kUkOdIZZP44UjcZt69YqzW/S1JKhGxLVOw=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = ''
    installShellCompletion --cmd popeye \
      --bash <($out/bin/popeye completion bash) \
      --fish <($out/bin/popeye completion fish) \
      --zsh <($out/bin/popeye completion zsh)
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    $out/bin/popeye version | grep ${version} > /dev/null
  '';

  meta = with lib; {
    description = "Kubernetes cluster resource sanitizer";
    mainProgram = "popeye";
    homepage = "https://github.com/derailed/popeye";
    changelog = "https://github.com/derailed/popeye/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = [ maintainers.bryanasdev000 ];
  };
}
