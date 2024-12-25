{
  stdenv,
  lib,
  buildGoModule,
  fetchFromGitHub,
  installShellFiles,
  buildPackages,
  versionCheckHook,
  nix-update-script,
  hugo,
}:

buildGoModule rec {
  pname = "hugo";
  version = "0.140.1";

  src = fetchFromGitHub {
    owner = "gohugoio";
    repo = "hugo";
    tag = "v${version}";
    hash = "sha256-9H7hXBz/rKJZr/XvqFRmOQylf6sfJtkwik3jh/k+Vec=";
  };

  vendorHash = "sha256-swcj1JxYoRqKscu/IC0uiAATp4AXN0aANWkSq/mJsyc=";

  checkFlags = [
    # Workaround for "failed to load modules"
    "-skip=TestCommands/mod"
  ];

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
  versionCheckProgram = "${placeholder "out"}/bin/${meta.mainProgram}";
  versionCheckProgramArg = [ "version" ];

  passthru.updateScript = nix-update-script { };

  meta = {
    changelog = "https://github.com/gohugoio/hugo/releases/tag/v${version}";
    description = "Fast and modern static website engine";
    homepage = "https://gohugo.io";
    license = lib.licenses.asl20;
    mainProgram = "hugo";
    maintainers = with lib.maintainers; [
      schneefux
      Br1ght0ne
      Frostman
    ];
  };
}
