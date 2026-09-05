{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
let
  version = "1.17.0";
in
buildGoModule {
  pname = "algolia-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "algolia";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-a+Ln+WNZkTi2/X31No40M0cu8crKyQcQnukWuU3CJDg=";
  };

  vendorHash = "sha256-gCNmvsQMNC7KQnXJODqmn59OllxI8+ViruOMLu600n4=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/algolia" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/algolia/cli/pkg/version.Version=${version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd algolia \
      --bash <($out/bin/algolia completion bash) \
      --fish <($out/bin/algolia completion fish) \
      --zsh <($out/bin/algolia completion zsh)
  '';

  meta = {
    description = "Algolia’s official CLI devtool";
    mainProgram = "algolia";
    homepage = "https://algolia.com/doc/tools/cli/";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
