{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
}:

buildGoModule (finalAttrs: {
  pname = "pv-migrate";
  version = "3.6.1";

  src = fetchFromGitHub {
    owner = "utkuozdemir";
    repo = "pv-migrate";
    tag = "v${finalAttrs.version}";
    sha256 = "sha256-ZAQ4jXSV8foQNptg3DOwUjkXQQR89yt/E6PjDIvmy6g=";
  };

  subPackages = [ "cmd/pv-migrate" ];

  vendorHash = "sha256-lGUVjCBSrgFPk00usKF8sUnjLyiuSRFmbyBbmDWB/14=";

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${finalAttrs.version}"
    "-X main.commit=${finalAttrs.version}"
    "-X main.date=1970-01-01-00:00:01"
  ];

  nativeBuildInputs = [
    installShellFiles
  ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd pv-migrate \
      --bash <($out/bin/pv-migrate completion bash) \
      --fish <($out/bin/pv-migrate completion fish) \
      --zsh <($out/bin/pv-migrate completion zsh)
  '';

  meta = {
    mainProgram = "pv-migrate";
    description = "CLI tool to easily migrate Kubernetes persistent volumes";
    homepage = "https://github.com/utkuozdemir/pv-migrate";
    changelog = "https://github.com/utkuozdemir/pv-migrate/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.afl20;
    maintainers = with lib.maintainers; [
      ivankovnatsky
      qjoly
    ];
  };
})
