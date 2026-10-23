{
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  lib,
  writableTmpDirAsHomeHook,
}:

buildGoModule (finalAttrs: {
  pname = "dapr-cli";
  version = "1.19.0";

  src = fetchFromGitHub {
    owner = "dapr";
    repo = "cli";
    rev = "v${finalAttrs.version}";
    hash = "sha256-6c23u6PS8KwfkUr4nj6A2Q/jsRlGM0CzHdqKIodNQ+c=";
  };

  vendorHash = "sha256-P7zrfUcb/Hxo7QbIQfq9JSf2d7meZShQ++GG8HkEoLE=";

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
