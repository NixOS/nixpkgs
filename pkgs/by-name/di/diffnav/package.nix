{
  lib,
  stdenv,
  fetchFromGitHub,
  buildGoModule,
  makeBinaryWrapper,
  installShellFiles,
  delta,
}:

buildGoModule (finalAttrs: {
  pname = "diffnav";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "dlvhdr";
    repo = "diffnav";
    tag = "v${finalAttrs.version}";
    hash = "sha256-LX7F8oSx+22EEhimp5qQmOYLHUux/ti1ytpGL2qIMRg=";
  };

  vendorHash = "sha256-5A1O3QbiWx3xF8Mp3Pm1rT40UrYCBm0NuHtk/c217IE=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/dlvhdr/diffnav/pkg/version.Version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [
    makeBinaryWrapper
    installShellFiles
  ];
  postInstall = ''
    wrapProgram $out/bin/diffnav \
      --prefix PATH : ${lib.makeBinPath [ delta ]}
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd diffnav \
     --bash <($out/bin/diffnav completion bash) \
     --fish <($out/bin/diffnav completion fish) \
     --zsh <($out/bin/diffnav completion zsh)
  '';

  meta = {
    changelog = "https://github.com/dlvhdr/diffnav/releases/tag/${finalAttrs.src.rev}";
    description = "Git diff pager based on delta but with a file tree, à la GitHub";
    homepage = "https://github.com/dlvhdr/diffnav";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
    mainProgram = "diffnav";
  };
})
