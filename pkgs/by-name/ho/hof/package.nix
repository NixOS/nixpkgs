{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule rec {
  pname = "hof";
  version = "0.6.9-beta.1";

  src = fetchFromGitHub {
    owner = "hofstadter-io";
    repo = "hof";
    rev = "v${version}";
    hash = "sha256-4yVP6DRHrsp52VxBhr7qppPhInYEsvPbIfxxQcRwHTw=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-cDUcYwcxPn+9TEP5lhVJXofijCZX94Is+Qt41PqUgjI=";

  subPackages = [ "./cmd/hof/main.go" ];

  postInstall = ''
    mv $out/bin/main $out/bin/hof
    local INSTALL="$out/bin/hof"
    installShellCompletion --cmd hof \
      --bash <($out/bin/hof completion bash) \
      --fish <($out/bin/hof completion fish) \
      --zsh <($out/bin/hof completion zsh)
  '';

  meta = with lib; {
    homepage = "https://github.com/hofstadter-io/hof";
    description = "Framework that joins data models, schemas, code generation, and a task engine. Language and technology agnostic";
    license = licenses.asl20;
    maintainers = with maintainers; [ jfvillablanca ];
    mainProgram = "hof";
  };
}
