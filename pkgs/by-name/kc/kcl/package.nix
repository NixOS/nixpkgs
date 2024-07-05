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
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "kcl-lang";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-zkVUTCUn4dNEN0j/IWV4LBF3BMWjaeUC0Ku8rMZFo8M=";
  };

  vendorHash = "sha256-9YevhWL1sdrwjG7vhDfBf/o60OK/CvccSd0KibAiiyk=";

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
