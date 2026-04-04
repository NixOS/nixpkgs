{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
let
  version = "1.7.3";
in
buildGoModule {
  pname = "algolia-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "algolia";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-m7PAD9EKrl7eBzRwCHDcH+eBcFnfXIDnIm6wvOtay5g=";
  };

  vendorHash = "sha256-I6awzstThs0nC/Nyy00jCN3cpF1MXJcFTUM95E38HQI=";

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
    maintainers = with lib.maintainers; [ momeemt ];
  };
}
