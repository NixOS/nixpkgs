{
  lib,
  stdenv,
  buildGoModule,
  installShellFiles,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gum";
  version = "0.16.1";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "gum";
    rev = "v${version}";
    hash = "sha256-3tn126Ars64ZhOY68aCrE7j14YDVGmllbHvYMHAgLR0=";
  };

  vendorHash = "sha256-SsnULG12NjyetLhL7vYjjpDI8vqqdeSyoZj0U3KP/nI=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags =
    [
      "-s"
      "-w"
      "-X=main.Version=${version}"
    ]
    ++ lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isStatic) [
      "-linkmode=external"
      "-extldflags"
      "-static"
    ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/gum man > gum.1
    installManPage gum.1
    installShellCompletion --cmd gum \
      --bash <($out/bin/gum completion bash) \
      --fish <($out/bin/gum completion fish) \
      --zsh <($out/bin/gum completion zsh)
  '';

  meta = {
    description = "Tasty Bubble Gum for your shell";
    homepage = "https://github.com/charmbracelet/gum";
    changelog = "https://github.com/charmbracelet/gum/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ maaslalani ];
    mainProgram = "gum";
  };
}
