{
  lib,
  stdenv,
  buildGoModule,
  installShellFiles,
  fetchFromGitHub,
}:

buildGoModule (finalAttrs: {
  pname = "gum";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "gum";
    rev = "v${finalAttrs.version}";
    hash = "sha256-KTRoxYeAT3t4GLWrgmJ6AUD5jnmB3iWBRtqSRzd3z0U=";
  };

  vendorHash = "sha256-HkBg28oJw5wkK221T79D2shQ+ZdK+EJFemYU2xNhBA0=";

  nativeBuildInputs = [
    installShellFiles
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
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
    changelog = "https://github.com/charmbracelet/gum/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      savtrip
    ];
    mainProgram = "gum";
  };
})
