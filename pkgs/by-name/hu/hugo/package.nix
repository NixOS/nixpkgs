{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  buildPackages,
  versionCheckHook,
  nix-update-script,
}:

buildGoModule (finalAttrs: {
  pname = "hugo";
  version = "0.146.4";

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = "hugo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-acOHFKNtzGV6CAhdBBBWAyS9Iuf3rq4XaIUnf2m6UWE=";
  };

  vendorHash = "sha256-LSNy65sIuq/zK3swdUvxGwbo/3ulq+JP5ur7M7aTdAs=";

  checkFlags =
    let
      skippedTestPrefixes = [
        # Workaround for "failed to load modules"
        "TestCommands/mod"
        # Server tests are flaky, at least in x86_64-darwin. See #368072
        # We can try testing again after updating the `httpget` helper
        # ref: https://github.com/gohugoio/hugo/blob/v0.140.1/main_test.go#L220-L233
        "TestCommands/server"
      ];
    in
    [ "-skip=^${builtins.concatStringsSep "|^" skippedTestPrefixes}" ];

  proxyVendor = true;

  tags = [
    "extended"
    "withdeploy"
  ];

  subPackages = [ "." ];

  nativeBuildInputs = [ installShellFiles ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/gohugoio/hugo/common/hugo.vendorInfo=nixpkgs"
  ];

  postInstall =
    let
      emulator = stdenv.hostPlatform.emulator buildPackages;
    in
    ''
      ${emulator} $out/bin/hugo gen man
      installManPage man/*
      installShellCompletion --cmd hugo \
        --bash <(${emulator} $out/bin/hugo completion bash) \
        --fish <(${emulator} $out/bin/hugo completion fish) \
        --zsh  <(${emulator} $out/bin/hugo completion zsh)
    '';

  nativeInstallCheckInputs = [
    versionCheckHook
  ];
  doInstallCheck = true;
  versionCheckProgram = "${placeholder "out"}/bin/hugo";
  versionCheckProgramArg = "version";

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/gohugoio/hugo/releases/tag/v${finalAttrs.version}";
    description = "Fast and modern static website engine";
    homepage = "https://gohugo.io";
    license = lib.licenses.asl20;
    mainProgram = "hugo";
    maintainers = with lib.maintainers; [
      schneefux
      Br1ght0ne
      Frostman
      kachick
      federicoschonborn
    ];
  };
})
