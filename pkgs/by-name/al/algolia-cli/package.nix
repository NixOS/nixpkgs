{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
let
  version = "1.18.0";
in
buildGoModule {
  pname = "algolia-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "algolia";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-b/P+RvLKkAxu2Wr71bS7BxjxrogeJs71umm6FupqkPQ=";
  };

  vendorHash = "sha256-25A4lnNZmGhA/P1Y30nvBbS3Q+UFNukJrdoPxA0Axto=";

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
