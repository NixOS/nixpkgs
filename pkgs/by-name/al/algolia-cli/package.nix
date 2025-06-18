{
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
let
  version = "1.7.0";
in
buildGoModule {
  pname = "algolia-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "algolia";
    repo = "cli";
    rev = "v${version}";
    hash = "sha256-j8OCN+iV5sMjgYTMGCc72JPImuFFvehKw4S99l+YWhs=";
  };

  vendorHash = "sha256-qzgkcmRuXHM9aMQGBObUHYH9qpWnDfTvwdx1A4it8aQ=";

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "cmd/algolia" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/algolia/cli/pkg/version.Version=${version}"
  ];

  postInstall = ''
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
