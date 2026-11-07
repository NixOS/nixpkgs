{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "dapr-cli";
  version = "1.19.1";

  src = fetchFromGitHub {
    owner = "dapr";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-toNZAdqESKohgrKkjhfx7qAwseJsYBgSyQZIT/1kNG4=";
  };

  vendorHash = "sha256-8zF+NXuSqypv52Eyy4QRcyLM60EiyVj9FLl6ky8PXWI=";

  proxyVendor = true;

  nativeBuildInputs = [ installShellFiles ];

  subPackages = [ "." ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  ldflags = [
    "-X main.version=${finalAttrs.version}"
    "-X main.apiVersion=1.0"
    "-X github.com/dapr/cli/pkg/standalone.gitcommit=${finalAttrs.src.rev}"
    "-X github.com/dapr/cli/pkg/standalone.gitversion=${finalAttrs.version}"
  ];

  postInstall = ''
    mv $out/bin/cli $out/bin/dapr

    installShellCompletion --cmd dapr \
      --bash <($out/bin/dapr completion bash) \
      --zsh <($out/bin/dapr completion zsh)
  '';

  meta = {
    description = "CLI for managing Dapr, the distributed application runtime";
    homepage = "https://dapr.io";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      joshvanl
      lucperkins
    ];
    mainProgram = "dapr";
  };
})
