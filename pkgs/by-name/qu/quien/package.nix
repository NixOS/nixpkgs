{
  buildGoModule,
  fetchFromGitHub,
  lib,
  nix-update-script,
  stdenvNoCC,
  installShellFiles,
}:

buildGoModule rec {
  pname = "quien";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "retlehs";
    repo = "quien";
    tag = "v${version}";
    hash = "sha256-c7uZZjv+cEZYv+tWDv+6+DTsrsgYoy1mCWsvhmK8Y7E=";
  };

  vendorHash = "sha256-q1HAlPIYe/nd5pYW+vZIABxfASlcFXhGNV71SY2ggsc=";

  subPackages = [ "." ];

  ldflags = [
    "-s"
    "-w"
    "-X main.version=${version}"
  ];

  nativeBuildInputs = [ installShellFiles ];

  postInstall = lib.optionalString (stdenvNoCC.buildPlatform.canExecute stdenvNoCC.hostPlatform) ''
    installShellCompletion --cmd quien \
      --bash <($out/bin/quien completion bash) \
      --fish <($out/bin/quien completion fish) \
      --zsh <($out/bin/quien completion zsh)
  '';

  passthru.updateScript = nix-update-script { };

  __structuredAttrs = true;
  strictDeps = true;

  meta = with lib; {
    description = "A better WHOIS lookup tool";
    homepage = "https://benword.com/quien-a-better-whois-lookup-tool";
    changelog = "https://github.com/retlehs/quien/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ myzel394 ];
    mainProgram = "quien";
    platforms = platforms.linux ++ platforms.darwin;
  };
}
