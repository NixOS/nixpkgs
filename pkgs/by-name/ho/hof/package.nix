{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  stdenv,
}:

buildGoModule rec {
  pname = "hof";
  version = "0.6.10";

  src = fetchFromGitHub {
    owner = "hofstadter-io";
    repo = "hof";
    rev = "v${version}";
    hash = "sha256-okc11mXqB/PaXd0vsRuIIL70qWSFprvsZJtE6PvCaIg=";
  };

  nativeBuildInputs = [ installShellFiles ];

  vendorHash = "sha256-mLOWnHzKw/B+jFNuswejEnYbPxFkk95I/BWeHRTH55I=";

  subPackages = [ "./cmd/hof" ];

  postInstall = ''
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
    # Broken on darwin for Go toolchain > 1.22, with error:
    # 'panic: open /etc/protocols: operation not permitted'
    broken = stdenv.hostPlatform.isDarwin;
  };
}
