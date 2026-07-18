{
  lib,
  buildGoModule,
  callPackage,
  fetchFromGitHub,
  testers,
  nixosTests,
  caddy,
  installShellFiles,
  stdenv,
  writableTmpDirAsHomeHook,
  versionCheckHook,
}:

buildGoModule (finalAttrs: {
  pname = "caddy";
  version = "2.11.4";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = "caddy";
    tag = "v${finalAttrs.version}";
    # remember to update hashes for `dist` and `plugins` test!
    hash = "sha256-wzk8KRZfDCbbjRlBwkoKAoMjOhV4xF3yuXUueqtl1xM=";
  };

  vendorHash = "sha256-2GwSM7EKN9GwN6kte7CekpXIJ0vzHhhsnrs3TC6vTW4=";

  ldflags = [
    "-s"
    "-w"
    "-X github.com/caddyserver/caddy/v2.CustomVersion=${finalAttrs.version}"
  ];

  # matches upstream since v2.8.0
  tags = [
    "nobadger"
    "nomysql"
    "nopgx"
  ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  __darwinAllowLocalNetworking = true;

  postInstall = ''
    install -Dm644 ${finalAttrs.passthru.dist}/init/caddy.service ${finalAttrs.passthru.dist}/init/caddy-api.service -t $out/lib/systemd/system

    substituteInPlace $out/lib/systemd/system/caddy.service \
      --replace-fail "/usr/bin/caddy" "$out/bin/caddy"
    substituteInPlace $out/lib/systemd/system/caddy-api.service \
      --replace-fail "/usr/bin/caddy" "$out/bin/caddy"
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    # Generating man pages and completions fail on cross-compilation
    # https://github.com/NixOS/nixpkgs/issues/308283

    $out/bin/caddy manpage --directory manpages
    installManPage manpages/*

    installShellCompletion --cmd caddy \
      --bash <($out/bin/caddy completion bash) \
      --fish <($out/bin/caddy completion fish) \
      --zsh <($out/bin/caddy completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [
    writableTmpDirAsHomeHook
    versionCheckHook
  ];
  versionCheckKeepEnvironment = [ "HOME" ];

  passthru = {
    withPlugins = callPackage ./plugins.nix { inherit caddy; };

    dist = fetchFromGitHub {
      owner = "caddyserver";
      repo = "dist";
      tag = "v${finalAttrs.version}";
      hash = "sha256-oRQfQH1GKjAjVMj+dZo1f1+HOaOdJIyEfod0iGLYcc8=";
    };

    tests = {
      inherit (nixosTests) caddy;
      plugins = testers.runNixOSTest ./plugins.test.nix;
      acme-integration = nixosTests.acme.caddy;
    };
  };

  meta = {
    homepage = "https://caddyserver.com";
    description = "Fast and extensible multi-platform HTTP/1-2-3 web server with automatic HTTPS";
    changelog = "https://github.com/caddyserver/caddy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "caddy";
    maintainers = with lib.maintainers; [
      stepbrobd
      techknowlogick
      ryan4yin
    ];
  };
})
