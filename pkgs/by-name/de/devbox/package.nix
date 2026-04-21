{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  stdenv,
}:
buildGoModule (finalAttrs: {
  pname = "devbox";
  version = "0.17.2";

  src = fetchFromGitHub {
    owner = "jetify-com";
    repo = "devbox";
    tag = finalAttrs.version;
    hash = "sha256-4K7Y0GxMhnhlQP30NGAAqJSgEo6aTNCsUoOfaa+aYkE=";
  };

  ldflags = [
    "-s"
    "-w"
    "-X go.jetify.com/devbox/internal/build.Version=${finalAttrs.version}"
  ];

  subPackages = [ "cmd/devbox" ];

  # integration tests want file system access
  doCheck = false;

  vendorHash = "sha256-zZUE0J6w1QbdMAKOt1xH3ql4G5FbaUgtD4Xpsw/tmIk=";

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
