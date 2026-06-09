{
  lib,
  stdenv,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  makeWrapper,
  dart-sass,
  git,
}:

buildGoModule (finalAttrs: {
  pname = "shopware-cli";
  version = "0.15.3";
  src = fetchFromGitHub {
    repo = "shopware-cli";
    owner = "shopware";
    tag = finalAttrs.version;
    hash = "sha256-3Bx3GaCR/yrvxsMrDYriwYaxUSIduW5WLhLtZDEJnsw=";
  };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];
  nativeCheckInputs = [
    git
    dart-sass
  ];

  vendorHash = "sha256-mQLRSX68cJVvY9Dj51qaDDNv04LuyJnRIqiw0SzLxpc=";

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd shopware-cli \
      --bash <($out/bin/shopware-cli completion bash) \
      --zsh <($out/bin/shopware-cli completion zsh) \
      --fish <($out/bin/shopware-cli completion fish)
  '';

  preFixup = ''
    wrapProgram $out/bin/shopware-cli \
      --prefix PATH : ${lib.makeBinPath [ dart-sass ]}
  '';

  ldflags = [
    "-s"
    "-w"
    "-X 'github.com/shopware/shopware-cli/cmd.version=${finalAttrs.version}'"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Command line tool for Shopware 6";
    mainProgram = "shopware-cli";
    homepage = "https://github.com/shopware/shopware-cli";
    changelog = "https://github.com/shopware/shopware-cli/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shyim ];
  };
})
