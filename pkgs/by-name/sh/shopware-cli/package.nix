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
  version = "0.14.8";
  src = fetchFromGitHub {
    repo = "shopware-cli";
    owner = "FriendsOfShopware";
    tag = finalAttrs.version;
    hash = "sha256-yN6yuGnZv6BsXoERUdA3aBGEmri1hqmPsbIYsX7HE5Q=";
  };

  nativeBuildInputs = [
    installShellFiles
    makeWrapper
  ];
  nativeCheckInputs = [
    git
    dart-sass
  ];

  vendorHash = "sha256-itrSY18wZnY0j4wq2mJ+2ugM0A2SKORENJ0iwWg+s+U=";

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
    "-X 'github.com/FriendsOfShopware/shopware-cli/cmd.version=${finalAttrs.version}'"
  ];

  __darwinAllowLocalNetworking = true;

  meta = {
    description = "Command line tool for Shopware 6";
    mainProgram = "shopware-cli";
    homepage = "https://github.com/FriendsOfShopware/shopware-cli";
    changelog = "https://github.com/FriendsOfShopware/shopware-cli/releases/tag/${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ shyim ];
  };
})
