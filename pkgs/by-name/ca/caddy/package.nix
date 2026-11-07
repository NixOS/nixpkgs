{
  lib,
  stdenv,
  buildPackages,
  callPackage,
  buildGoLatestModule,
  fetchFromGitHub,
  installShellFiles,
  versionCheckHook,
  writableTmpDirAsHomeHook,
  testers,
  nixosTests,
  nix-update-script,
}:

buildGoLatestModule (finalAttrs: {
  pname = "caddy";
  version = "2.11.9";

  __structuredAttrs = true;

  __darwinAllowLocalNetworking = true;

  src = fetchFromGitHub {
    owner = "caddyserver";
    repo = "caddy";
    tag = "v${finalAttrs.version}";
    # remember to update hashes for `dist` and `plugins` test!
    hash = "sha256-K7irjePU998bcbKANXpTf0npirSh+tkc8D3x4JmRdbg=";
  };

  vendorHash = "sha256-qjLumZHCyoM+lNZtWOTmMlHN5zgB36fv9CkIq3ncMlM=";

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

  # Use only the system CA store. The embedded fallback bundle does not get cacert updates.
  # goModules does not run postConfigure, so vendorHash stays the same.
  postConfigure = ''
    rm cmd/x509rootsfallback.go
  '';

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
      hash = "sha256-v9VaNgkWekTPI5nt04QoyZeJRRvymK2q0o3JxygC2JA=";
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
