{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:
buildGoModule (finalAttrs: {
  pname = "devbox";
  version = "0.22.0";

  src = fetchFromGitHub {
    owner = "jetify-com";
    repo = "devbox";
    tag = finalAttrs.version;
    hash = "sha256-/qXHaUubRCVESbPrnxabdXP/0uUk0DSIUGSsWvKV2S0=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X go.jetify.com/devbox/internal/build.Version=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/devbox" ];

  # integration tests want file system access
  doCheck = false;

  vendorHash = "sha256-YrE6OR+21Nwf6EFAJkZk7HSN3t+JzA4TgRNH+ziQYYQ=";

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd devbox \
      --bash <($out/bin/devbox completion bash) \
      --fish <($out/bin/devbox completion fish) \
      --zsh <($out/bin/devbox completion zsh)
  '';

  meta = {
    description = "Instant, easy, predictable shells and containers";
    homepage = "https://www.jetify.com/devbox";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      lagoja
      madeddie
    ];
  };
})
