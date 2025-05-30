{
  lib,
  stdenv,
  buildGoModule,
  installShellFiles,
  fetchFromGitHub,
}:

buildGoModule rec {
  pname = "gum";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "gum";
    rev = "v${version}";
    hash = "sha256-77102I7pOGfpPBSGelsA/9GJYos05akF0kdmr522RC0=";
  };

  vendorHash = "sha256-wrl4Zo5NSaTTMrc95Fs9cevG7ITJtHuV3pGkFd8jpxU=";

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

  meta = with lib; {
    description = "Tasty Bubble Gum for your shell";
    homepage = "https://github.com/charmbracelet/gum";
    changelog = "https://github.com/charmbracelet/gum/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ maaslalani ];
    mainProgram = "gum";
  };
}
