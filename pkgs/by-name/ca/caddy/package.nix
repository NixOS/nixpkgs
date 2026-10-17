{
  lib,
  stdenv,
  buildPackages,
  callPackage,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  testers,
  nixosTests,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "caddy";
  version = "2.11.7";

  __structuredAttrs = true;

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = "caddy";
    tag = "v${finalAttrs.version}";
    # remember to update hashes for `dist` and `plugins` test!
    hash = "sha256-6+USPwF6LzDWUjrNRL2ncxSz5KmqJM0L/6o03Lh8YD8=";
  };

  vendorHash = "sha256-kJOl5h9gSfEK6ROT/MYOkBUr6MhiNBlbZVZPqwNpbBk=";

  ldflags = [
    "-s"
    "-X github.com/caddyserver/caddy/v2.CustomVersion=v${finalAttrs.version}"
  ];

  # matches upstream since v2.8.0
  tags = [
    "nobadger"
    "nomysql"
    "nopgx"
  ];

  nativeBuildInputs = [ installShellFiles ];

  nativeCheckInputs = [ writableTmpDirAsHomeHook ];

  checkFlags = [ "-skip=^TestReverseProxySNIPlaceHolder$" ];

  postInstall = ''
    install -Dm644 ${finalAttrs.passthru.dist}/init/caddy.service ${finalAttrs.passthru.dist}/init/caddy-api.service -t $out/lib/systemd/system

    substituteInPlace $out/lib/systemd/system/caddy.service $out/lib/systemd/system/caddy-api.service \
      --replace-fail "/usr/bin/caddy" "$out/bin/caddy"
  ''
  + lib.optionalString (stdenv.hostPlatform.emulatorAvailable buildPackages) (
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      ${emulator} $out/bin/caddy manpage --directory manpages
      installManPage manpages/*

      installShellCompletion --cmd caddy \
        --bash <(${emulator} $out/bin/caddy completion bash) \
        --fish <(${emulator} $out/bin/caddy completion fish) \
        --zsh <(${emulator} $out/bin/caddy completion zsh)
    ''
  );

  doInstallCheck = true;
  versionCheckKeepEnvironment = [ "HOME" ];
  nativeInstallCheckInputs = [
    versionCheckHook
    writableTmpDirAsHomeHook
  ];

  passthru = {
    withPlugins = callPackage ./plugins.nix { caddy = finalAttrs.finalPackage; };

    dist = fetchFromGitHub {
      owner = "caddyserver";
      repo = "dist";
      tag = "v${finalAttrs.version}";
      hash = "sha256-KvdaqiX06I1ft+p67J1ISgP512SoZ4syDzfe888ZqGI=";
    };

    updateScript = nix-update-script {
      extraArgs = [
        "--custom-dep"
        "dist"
      ];
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
