{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  git,
  installShellFiles,
  testers,
  roborev,
}:

buildGoModule (finalAttrs: {
  pname = "roborev";
  version = "0.39.0";

  src = fetchFromGitHub {
    owner = "roborev-dev";
    repo = "roborev";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oxiJwGxiEkxJH2Ao6aHXwYuqerZii26sIYydLfCZA6g=";
  };

  vendorHash = "sha256-9jLxJ4iKuuAAxF8eNbRCoTMv+WmQjGIOl3PC0HZOi6M=";

  subPackages = [ "cmd/roborev" ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/roborev-dev/roborev/internal/version.Version=v${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [ git ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd roborev \
      --bash <($out/bin/roborev completion bash) \
      --fish <($out/bin/roborev completion fish) \
      --zsh <($out/bin/roborev completion zsh)
  '';

  passthru.tests.version = testers.testVersion {
    package = roborev;
    command = "roborev version";
    version = "v${finalAttrs.version}";
  };

  meta = {
    description = "Continuous background code review for coding agents";
    homepage = "https://github.com/roborev-dev/roborev";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ ];
    mainProgram = "roborev";
  };
})
