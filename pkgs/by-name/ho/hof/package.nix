{
  lib,
  buildGo122Module,
  fetchFromGitHub,
  installShellFiles,
}:

buildGo122Module rec {
  pname = "hof";
  version = "0.6.9";

  src = fetchFromGitHub {
    owner = "hofstadter-io";
    repo = "hof";
    rev = "v${version}";
    hash = "sha256-okY+CkPnlndy5H4M1+T1CY21+63+KPBinHoa5+8kQ2M=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-SmUEVWIyV6k5Lu5zeKGqpij3zUNRZQmIgtf8/Hf7UUs=";

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
