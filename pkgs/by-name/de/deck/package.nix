{
  buildGoModule,
  stdenv,
  lib,
  installShellFiles,
  fetchFromGitHub,
  nix-update-script,
}:

buildGoModule rec {
  pname = "deck";
  version = "1.52.1";

  src = fetchFromGitHub {
    owner = "Kong";
    repo = "deck";
    tag = "v${version}";
    hash = "sha256-nxb7iuAf1hGHdjomgxFZuYwZSUuRrd5J3iVtFgEINY4=";
  };

  nativeBuildInputs = [ installShellFiles ];

  env.CGO_ENABLED = 0;

  ldflags = [
    "-s -w -X github.com/kong/deck/cmd.VERSION=${version}"
    "-X github.com/kong/deck/cmd.COMMIT=${src.rev}"
  ];

  proxyVendor = true; # darwin/linux hash mismatch
  vendorHash = "sha256-K6BOZ0LAy107UMQ0ZjkSnI4Q0lSqfHqvIG+EhCaal9A=";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd deck \
      --bash <($out/bin/deck completion bash) \
      --fish <($out/bin/deck completion fish) \
      --zsh <($out/bin/deck completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Configuration management and drift detection tool for Kong";
    homepage = "https://github.com/Kong/deck";
    license = lib.licenses.asl20;
    mainProgram = "deck";
    maintainers = with lib.maintainers; [ liyangau ];
  };
}
