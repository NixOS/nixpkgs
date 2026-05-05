{
  lib,
  stdenv,
  buildGoModule,
  installShellFiles,
  fetchFromGitHub,
  shellCompletionHook,
}:

buildGoModule (finalAttrs: {
  pname = "pop";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "charmbracelet";
    repo = "pop";
    rev = "v${finalAttrs.version}";
    hash = "sha256-e1xkUXFC1C18nj/eTo2PmHGORKZ1cmz+s0I47SOcTiM=";
  };

  vendorHash = "sha256-r2kKHwjUqls1nEOF0HwBMOZksSYp2UcjN+B0c1i8MmQ=";

  env.GOWORK = "off";

  nativeBuildInputs = [
    installShellFiles
  ]
  ++ lib.optionals (stdenv.buildPlatform.canExecute stdenv.hostPlatform) [
    shellCompletionHook
  ];

  ldflags = [
    "-s"
    "-w"
    "-X=main.Version=${finalAttrs.version}"
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $out/bin/pop man > pop.1
    installManPage pop.1
  '';

  meta = {
    description = "Send emails from your terminal";
    homepage = "https://github.com/charmbracelet/pop";
    changelog = "https://github.com/charmbracelet/pop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      caarlos0
    ];
    mainProgram = "pop";
  };
})
