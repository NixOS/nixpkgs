{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:
let
  version = "1.10.5";
in
buildGoModule {
  pname = "algolia-cli";
  inherit version;

  src = fetchFromGitHub {
    owner = "algolia";
    repo = "cli";
    tag = "v${version}";
    hash = "sha256-PnwU5xvdksT9VEMHP24KM2Q53XEmFJc6V68hkr06OPo=";
  };

  vendorHash = "sha256-RvkQu7Q3TioumrgUCX/6TzuDVHKhgX4WG9PSCh5Hp9Q=";

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
