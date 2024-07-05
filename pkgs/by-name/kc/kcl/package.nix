{ lib
, buildGoModule
, fetchFromGitHub
, kclvm_cli
, kclvm
, makeWrapper
, installShellFiles
,
}:
buildGoModule rec {
  pname = "kcl";
  version = "0.8.9";

  src = fetchFromGitHub {
    owner = "kcl-lang";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-slU3n7YCV5VfvXArzlcITb9epdu/gyXlAWq9KLjGdJA=";
  };

  vendorHash = "sha256-Xv8Tfq9Kb1xGFCWZQwBFDX9xZW9j99td/DUb7jBtkpE=";

  ldflags = [
    "-w -s"
    "-X=kcl-lang.io/cli/pkg/version.version=v${version}"
  ];

  nativeBuildInputs = [ makeWrapper installShellFiles ];
  buildInputs = [ kclvm kclvm_cli ];

  subPackages = [ "cmd/kcl" ];

  # env vars https://github.com/kcl-lang/kcl-go/blob/main/pkg/env/env.go#L29
  postFixup = ''
     wrapProgram $out/bin/kcl \
    --set PATH ${lib.makeBinPath [kclvm_cli]} \
    --set KCL_LIB_HOME ${lib.makeLibraryPath [kclvm]} \
    --set KCL_GO_DISABLE_INSTALL_ARTIFACT false \
  '';

  postInstall = ''
    installShellCompletion --cmd kcl \
      --bash <($out/bin/kcl completion bash) \
      --fish <($out/bin/kcl completion fish) \
      --zsh <($out/bin/kcl completion zsh)
  '';

  meta = with lib; {
    description = "A command line interface for KCL programming language";
    homepage = "https://github.com/kcl-lang/cli";
    license = licenses.asl20;
    platforms = platforms.linux;
    maintainers = with maintainers; [ selfuryon peefy ];
    mainProgram = "kcl";
  };
}
