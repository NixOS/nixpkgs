{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:
buildGoModule (finalAttrs: {
  pname = "devbox";
  version = "0.18.2";

  src = fetchFromGitHub {
    owner = "jetify-com";
    repo = "devbox";
    tag = finalAttrs.version;
    hash = "sha256-MatpzWBdGRyHvOcUYVTKzHDXYYR17GThRFeRv9FYznI=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X go.jetify.com/devbox/internal/build.Version=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/devbox" ];

  # integration tests want file system access
  doCheck = false;

  vendorHash = "sha256-Jyql54LvdqnTHAlyLP1M8hHZGyhFWVCGgWC505AjpQ4=";

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
