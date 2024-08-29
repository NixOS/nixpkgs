{ lib
, stdenv
, buildGoModule
, fetchFromGitHub
, kclvm_cli
, kclvm
, makeWrapper
, installShellFiles
, darwin
,
}:
buildGoModule rec {
  pname = "kcl";
  version = "0.9.8";

  src = fetchFromGitHub {
    owner = "kcl-lang";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-s8pFnItmw3+l9GKqdqX0Rxsy47h6vO+yUtVNCuyn/m8=";
  };

  vendorHash = "sha256-DGYYH5sKhpcWHYoUim4NyflzqsXFc4MCOqIw5jIfIiM=";

  # By default, libs and bins are stripped. KCL will crash on darwin if they are.
  dontStrip = stdenv.isDarwin;

  ldflags = [
    "-w -s"
    "-X=kcl-lang.io/cli/pkg/version.version=v${version}"
  ];

  nativeBuildInputs = [ makeWrapper installShellFiles ];

  buildInputs = [ kclvm kclvm_cli ] ++ (
    lib.optional stdenv.isDarwin [
      darwin.apple_sdk.frameworks.Security
      darwin.apple_sdk.frameworks.CoreServices
      darwin.apple_sdk.frameworks.SystemConfiguration
    ]
  );

  subPackages = [ "cmd/kcl" ];

  # env vars https://github.com/kcl-lang/kcl-go/blob/main/pkg/env/env.go#L29
  postFixup = ''
     wrapProgram $out/bin/kcl \
    --prefix PATH : "${lib.makeBinPath [kclvm kclvm_cli]}" \
    --prefix KCL_LIB_HOME : "${lib.makeLibraryPath [kclvm]}" \
    --prefix KCL_GO_DISABLE_INSTALL_ARTIFACT : false
  '';

  postInstall = ''
    export HOME=$(mktemp -d)
    installShellCompletion --cmd kcl \
      --bash <($out/bin/kcl completion bash) \
      --fish <($out/bin/kcl completion fish) \
      --zsh <($out/bin/kcl completion zsh)
  '';

  meta = with lib; {
    description = "A command line interface for KCL programming language";
    homepage = "https://github.com/kcl-lang/cli";
    license = licenses.asl20;
    platforms = platforms.linux ++ platforms.darwin;
    maintainers = with maintainers; [ selfuryon peefy ];
    mainProgram = "kcl";
  };
}
